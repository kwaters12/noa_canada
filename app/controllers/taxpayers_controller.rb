class TaxpayersController < ApplicationController
  before_action :find_taxpayer, except: [:index, :new, :create]
  before_action :find_agent
  require 'dropbox_sdk'
  
  def index
    @agent = current_agent
    @sub_brokerage = @agent.sub_brokerage
    @taxpayers = @agent.taxpayers.all

    respond_to do |format|
      format.html {render}
      format.json { render json: Taxpayer.all }
    end
  end

  def new 
    @taxpayer = Taxpayer.new
    # @order = Order.new
  end

  def create  
    @taxpayer = @agent.taxpayers.new(taxpayer_params)
    respond_to do |format|
      if @taxpayer.save
        @order = @agent.orders.new(order_params)
        @order.status = "Started"
        @order.taxpayer = @taxpayer
        @order.save

        if params[:documents]
          #===== The magic is here ;)
          params[:documents].each { |document|
            @order.assets.create(document: document)
          }
        end
        generate_pdf(@agent, @taxpayer, @order)          
        
        format.html { 
          redirect_to order_path(@order)
          # handle_payment(params[:payment_method], @order)
        }
        format.js
        format.json  { render json: @taxpayer.to_json(include: @order) }
      else
        format.html {
          redirect_to new_order_path, notice: "Sorry, your application was not saved"
        }
      end    
    end         
      
  end

  def hook
    params.permit!
    status = params[:payment_status]
    if status == "Completed" 
      @order = Order.find params[:invoice]
      @order.update_attributes notification_params: params, status: status, transaction_id: params[:txn_id], purchased_at: Time.now
    end
    render nothing: true
  end

  private

  def build_order(taxpayer)
    @order = @agent.orders.new(order_params)
    @order.status = "Started"
    @order.agent_id = current_agent.id
    @order.taxpayer_id = @taxpayer.id
    @order.save
  end

  def find_agent
    @agent = current_agent
  end

  def taxpayer_params
    params.require(:taxpayer).permit([:first_name, :last_name, :sin, :dob, :email, :phone_number, :agent_id])
  end

  def order_params
    params.require(:taxpayer).permit([:asset, :agent_id, :taxpayer_id])
  end

  def generate_pdf(agent, taxpayer, order)
    @dropbox_client = DropboxClient.new('fOObVAMBomkAAAAAAAAAWHCIPbIWTv7bwD3nHivV2EXLwV0WgKCJRYK9ykrWo8Ru')

    folder = @dropbox_client.search('/', folder_name)

    Rails.logger.info("*******************")
    Rails.logger.info(folder.inspect)
    Rails.logger.info("*******************")

    if folder.nil?
      @dropbox_client.file_create_folder(folder_name)
    end

    if order.assets
      order.assets.each do |asset|
        asset.pdf_path = pdf_path = "#{Rails.root}/public#{asset.document.url.split('?')[0]}"        
        move_pdf(pdf_path, asset)      
      end
      send_link(order)
    else    
      order.pdf_path = pdf_path = OrderPDFForm.new(taxpayer).export
      asset = order.assets.create(document: pdf_path)   
      move_pdf(pdf_path, asset)  
      send_link(order)  
    end   

    
    order.save    
  end

  def folder_name
    @agent.name_display + ' - ' + @agent.sub_brokerage.name + '/' + @taxpayer.sin + ' ' + @taxpayer.last_name + ', ' + @taxpayer.first_name
  end

  def file_name
    @taxpayer.sin + ' ' + @taxpayer.last_name + ', ' + @taxpayer.first_name + ' ' + Date.today.to_s +  '.pdf'
  end

  def move_pdf(pdf_path, asset)
    @dropbox_client.put_file('/' + folder_name + '/' + @taxpayer.last_name + ', ' + @taxpayer.first_name + ' ' +asset.document_file_name + ' ' + Date.today.to_s +  '.pdf', open(pdf_path), overwrite=true)
  end

  def send_link(order)
    # shareable = @dropbox_client.shares(folder_name + '/' + file_name)
    shareable = @dropbox_client.shares(folder_name)
    order.dropbox_url = shareable['url']   
  end
end
