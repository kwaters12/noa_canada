class TaxpayersController < ApplicationController
  before_action :find_taxpayer, except: [:index, :new, :create]
  before_action :find_agent

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
      @order.agent_id = current_agent.id
      @order.taxpayer_id = @taxpayer.id 
      @order.save
      respond_to do |format|
        format.html { 
          # redirect_to noa_application_path(@noa_application), notice: "Thank You!" 
          redirect_to root_url
        }
        format.js
        format.json  { render json: @client.to_json(include: @noa_application) }   
      end     
    else
      flash.now[:error] = "Sorry, your application was not saved"
      redirect_to new_order_path
    end 
  end

  private

  def find_agent
    @agent = current_agent
  end

  def taxpayer_params
    params.require(:taxpayer).permit([:first_name, :last_name, :sin, :dob, :email, :phone_number, :agent_id])  
  end

  def order_params
    params.require(:taxpayer).permit([:document])
  end
end
