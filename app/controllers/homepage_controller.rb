class HomepageController < ApplicationController

  def index
    @agent = current_agent
    if @agent && @agent.sub_brokerage.nil?
      redirect_to after_signup_path(:choose_type)
    end
    if @agent
      @sub_brokerage = @agent.sub_brokerage if @agent && @agent.sub_brokerage
      @orders = @agent.orders.all if @agent
      @complete_orders = @agent.orders.where(status: "Completed")
      @incomplete_orders = @agent.orders.where(status: "Started")
    end
   
  end
end
