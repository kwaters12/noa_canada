class OrdersController < ApplicationController
  before_action :find_agent, :find_sub_brokerage, except: [:hook]
  skip_before_filter :verify_authenticity_token, only: [:show]
  protect_from_forgery except: [:show, :hook] 

  def index
    @orders = Order.all

    respond_to do |format|
      format.html { render }
      format.json { render json: Order.all } 
    end
  end

  def new
    @order = @agent.orders.new
    @taxpayer = Taxpayer.new
  end

  def create
    if params[:taxpayer]
      find_taxpayer
    end
    @order = @agent.orders.new(order_params)
    @order.taxpayer = Taxpayer.find_or_create_by(params[:order][:email])
    @order.order_number = 100000 + "#{@order.id}".to_f
    respond_to do |format|
      if @order.save
          if params[:documents]
            #===== The magic is here ;)
            params[:documents].each { |document|
              @order.assets.create(document: document)
            }
          end

          format.html { redirect_to @order.paypal_url(order_path(@order)) }
          format.js
          format.json  { render json: @taxpayer.to_json(include: @order) }   
        #redirect_to root_url, notice: "Thank You!"
        
      else
        flash.now[:error] = "Sorry, your application was not saved"
        render :new
      end
      
     end

  end

  def show 
    @order = Order.find(params[:id])
    # if @order.status != 'Completed'
    #   handle_stripe_payment(@order)
    # end
    # if @order.document.exists? && params[:payment_status] == "Completed"
    #   redirect_to root_url, notice: "Your order has been received. You can view the details below."
    # elsif  @order.docusign_url.nil? && @order.document.nil?
    #   attach_docusign_signature(@order)
    # else !@order.docusign_url.nil?
    #   @url = @order.docusign_url
    # end
  end

  

  def docusign_response
    utility = DocusignRest::Utility.new
   
    if params[:event] == "signing_complete"
      get_document(params[:envelopeID])
      flash[:notice] = "Thanks! Successfully signed"
      render :text => utility.breakout_path(root_url), content_type: 'text/html'
    else
      get_document(params[:envelopeID])
      flash[:notice] = "You chose not to sign the document."
      render :text => utility.breakout_path(root_url), content_type: 'text/html'
    end
  end

  def paypal
    @order = Order.find(params[:format])
    taxpayer = Taxpayer.find(@order.taxpayer_id)
    # Rails.logger.info("^^^^^^^^^^^^^^^^")
    # Rails.logger.info(order.inspect)
    # Rails.logger.info("^^^^^^^^^^^^^^^^")
    ClientMailer.dropbox_link(taxpayer, @order.dropbox_url).deliver_now
    redirect_to @order.paypal_url(@order)
  end

  def hook
    params.permit!
    status = params[:payment_status]
    Rails.logger.info("%%%%%%%%%%%%%%%%")
    Rails.logger.info(params)
    Rails.logger.info("%%%%%%%%%%%%%%%%")
    if status == "Completed"
      @order = Order.find params[:invoice]
      @order.update_attributes notification_params: params, status: status, transaction_id: params[:txn_id], purchased_at: Time.now
    end
  end

  private

  def handle_stripe_payment(order)

  end

  def generate_order(client, order)
    order.pdf_path = client.pdf_path = pdf_path = NoaApplicationPDFForm.new(order).export

    @dropbox_client = DropboxClient.new('fOObVAMBomkAAAAAAAAAWHCIPbIWTv7bwD3nHivV2EXLwV0WgKCJRYK9ykrWo8Ru')

    folder = @dropbox_client.search('/', folder_name)
    if folder
      move_pdf(pdf_path)
      send_link
    else
      @dropbox_client.file_create_folder(folder_name)

      move_pdf(pdf_path)
      send_link
   
    end
    order.save
    client.save

   
    
  end

  def find_agent
    @agent = current_agent
  end

  def find_sub_brokerage
    @sub_brokerage = @agent.sub_brokerage
  end

  def find_taxpayer
    @taxpayer = Taxpayer.find_or_create_by(params[:taxpayer][:sin])
  end

  def attach_docusign_signature(order)
    @docusign = DocusignRest::Client.new
    output_path = order.pdf_path
    Rails.logger.info("$$$$$$$$$$$$$$$")
    Rails.logger.info(output_path)
    Rails.logger.info("$$$$$$$$$$$$$$$")
    
    document_envelope_response = @docusign.create_envelope_from_document(
      email: {
        subject: "test email subject",
        body: "this is the email body and it's large!"
      },
      # If embedded is set to true  in the signers array below, emails
      # don't go out to the signers and you can embed the signature page in an 
      # iFrame by using the client.get_recipient_view method
      signers: [
        {
          embedded: true,
          name: order.taxpayer.name_display,
          email: order.taxpayer.email,
          role_name: 'order',
          sign_here_tabs: [
            {
              anchor_string: 'Print name of taxpayer',
              anchor_x_offset: '140',
              anchor_y_offset: '8'
            },
            {
              anchor_string: 'Signature of taxpayer',
              anchor_x_offset: '140',
              anchor_y_offset: '80'
            }
          ]
        }
      ],
      files: [
        {path: output_path, name: 'order_pdf_form.pdf'},
      ],
      status: 'sent'
    )

    
    
    # @docusign.get_document_from_envelope(
    #   envelope_id: document_envelope_response["envelopeId"],
    #   document_id: 1,
    #   local_save_path: "#{Rails.root}/tmp/pdfs/#{SecureRandom.uuid}.pdf"
    # )
    Rails.logger.info("$$$$$$$$$$$$$$$")
    Rails.logger.info(document_envelope_response)
    Rails.logger.info("$$$$$$$$$$$$$$$")

    @url = @docusign.get_recipient_view(
      envelope_id: document_envelope_response["envelopeId"],
      name: order.taxpayer.name_display,
      email: order.taxpayer.email,
      return_url: "http://localhost:3000/docusign_response/envelopeID=" + document_envelope_response["envelopeId"]
    )
    @url.each do |key, value|
      order.docusign_url = value
    end
    
    order.save

    File.delete(output_path)

    return @url
  end

  def get_document(envelope)
    require "net/http"
    require "uri"

    client = DocusignRest::Client.new
    Rails.logger.info("$$$$$$$$$$$$$$$$$$$$")
    Rails.logger.info(client.inspect)
    Rails.logger.info("$$$$$$$$$$$$$$$$$$$$")


    uri = URI.parse("http://" + client.endpoint + "/restapi/" + client.api_version + "/accounts/" + client.account_id + "/envelopes/" + envelope + "/documents/combined")

    # Shortcut
    response = Net::HTTP.get_response(uri)

    # Will print response.body
    Net::HTTP.get_print(uri)

    # Full
    http = Net::HTTP.new(uri.host, uri.port)
    response = http.request(Net::HTTP::Get.new(uri.request_uri))
    
    # random = "#{Rails.root}/tmp/pdfs/#{SecureRandom.uuid}.pdf"
    # client.get_document_from_envelope(
    #   envelope_id: envelope,
    #   document_id: 1,
    #   local_save_path: "#{Rails.root}/tmp/pdfs/#{SecureRandom.uuid}.pdf"
    # )
    
  end

end
