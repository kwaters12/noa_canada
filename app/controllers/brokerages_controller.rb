class BrokeragesController < ApplicationController

  def index
    @brokerages = Brokerage.order(:name).where("name LIKE ?", "%#{params[:term]}%")
    render json: @brokerages.map(&:name)
  end

  def new 
    @brokerage = Brokerage.new
  end

  def create 
    @brokerage = Brokerage.new brokerage_params
    @brokerage.save
  end

  private

  def brokerage_params
    params.require(:brokerage).permit([:name, :address, :city, :postal_code, :province, :phone_number])
  end

end
