class HomepageController < ApplicationController

  def index
    @agent = current_agent
    @sub_brokerage = @agent.sub_brokerage if @agent && @agent.sub_brokerage
    @orders = @agent.orders.all if @agent
    @complete_orders = Order.where(status: "Complete")
    Rails.logger.info("$$$$$$$$$$$$$$$$")
    Rails.logger.info(@complete_orders)
    Rails.logger.info("$$$$$$$$$$$$$$$$")
    @incomplete_orders = Order.where(status: "Started")
  end
end
