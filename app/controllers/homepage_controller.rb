class HomepageController < ApplicationController

  def index
    @agent = current_agent
    @sub_brokerage = @agent.sub_brokerage if @agent && @agent.sub_brokerage
    @orders = @agent.orders.all if @agent
  end
end
