class HomepageController < ApplicationController

  def index
    @agent = current_agent
    if @agent && @agent.sub_brokerage.nil?
      redirect_to after_signup_path(:choose_type)
    end
    @sub_brokerage = @agent.sub_brokerage if @agent && @agent.sub_brokerage
    @orders = @agent.orders.all if @agent
    @complete_orders = Order.where(status: "Complete")

    @incomplete_orders = Order.where(status: "Started")
  end
end
