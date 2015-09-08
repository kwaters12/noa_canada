class OrdersController < ApplicationController
  before_action :find_agent, :find_sub_brokerage

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
    @order.taxpayer = @taxpayer
    
    if @order.save

        # generate_order(@order)
        respond_to do |format|
          format.html { redirect_to @order.paypal_url(order_path(@order, :format => 'pdf')) }
          format.js
          format.json  { render json: @taxpayer.to_json(include: @order) }   
        end 
        #redirect_to root_url, notice: "Thank You!"
        
      else
        flash.now[:error] = "Sorry, your application was not saved"
        render :new
      end
    
    else

  end

  private

  def find_agent
    @agent = current_agent
  end

  def find_sub_brokerage
    @sub_brokerage = @agent.sub_brokerage
  end

  def find_taxpayer
    @taxpayer = Taxpayer.find_or_create_by(params[:taxpayer][:sin])
  end

  def order_params

  end

end
