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
  end

  def create   
    @taxpayer = @agent.taxpayers.new(taxpayer_params)   
    if @taxpayer.save
      @order = @agent.orders.new(order_params)
      @order.status = "Started"
      @order.agent_id = current_agent.id
      @order.taxpayer_id = @taxpayer.id
      @order.save         
      generate_pdf(@taxpayer, @order)          
      respond_to do |format|
        format.html { 
          redirect_to order_path(@order)
          # handle_payment(params[:payment_method], @order)
        }
        format.js
        format.json  { render json: @taxpayer.to_json(include: @order) }
      end            
    else
      flash.now[:error] = "Sorry, your application was not saved"
      redirect_to new_order_path
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

  def find_agent
    @agent = current_agent
  end

  def taxpayer_params
    params.require(:taxpayer).permit([:first_name, :last_name, :sin, :dob, :email, :phone_number, :agent_id])  
  end

  def order_params
    params.require(:taxpayer).permit([:document, :order_number])
  end

  def generate_pdf(taxpayer, order)
    if !params[:taxpayer][:document]
      order.pdf_path = pdf_path = OrderPDFForm.new(taxpayer).export
    else    
      order.pdf_path = pdf_path = "#{Rails.root}/public#{order.document.url.split('?')[0]}"
    end
    
    @dropbox_client = DropboxClient.new('fOObVAMBomkAAAAAAAAAWHCIPbIWTv7bwD3nHivV2EXLwV0WgKCJRYK9ykrWo8Ru')

    folder = @dropbox_client.search('/', folder_name)
    if folder
      move_pdf(pdf_path)
      send_link(order)
    else
      @dropbox_client.file_create_folder(folder_name)

      move_pdf(pdf_path)
      send_link(order)  
    end

    
    order.save    
  end

  def folder_name
    @taxpayer.sin + ' ' + @taxpayer.last_name + ', ' + @taxpayer.first_name
  end

  def file_name
    @taxpayer.sin + ' ' + @taxpayer.last_name + ', ' + @taxpayer.first_name + ' ' + Date.today.to_s +  '.pdf'
  end

  def move_pdf(pdf_path)
    @dropbox_client.put_file('/' + folder_name + '/' + file_name, open(pdf_path), overwrite=true)
  end

  def send_link(order)
    # shareable = @dropbox_client.shares(folder_name + '/' + file_name)
    shareable = @dropbox_client.shares(folder_name)
    order.dropbox_url = shareable['url']   
    # ClientMailer.dropbox_link(@taxpayer, shareable['url']).deliver_now
  end
end
