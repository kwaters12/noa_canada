class SubBrokeragesController < ApplicationController
   def index
    @sub_brokerages = SubBrokerage.order(:name).where("name LIKE ?", "%#{params[:term]}%")
  
    render json: @sub_brokerages.map(&:name)
  end

  def new 
    @sub_brokerage = SubBrokerage.new
  end

  def create 
    @sub_brokerage = SubBrokerage.new sub_brokerage_params
    @sub_brokerage.save
  end

  private

  def sub_brokerage_params
    params.require(:sub_brokerage).require([:name, :address, :city, :postal_code, :province, :phone_number])
  end
end
