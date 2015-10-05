class MessagesController < ApplicationController

  def index
    @messages = Message.all
    render json: @messages.all
  end

  def new 
    @message = Message.new
  end

  def create 
    @message = Message.new message_params
    @message.agent = current_agent
    # @taxpayer = Taxpayer.find_or_create_by(email: params[:message][:email]) do |taxpayer|
    #   taxpayer.first_name       = params[:message][:first_name]
    #   taxpayer.last_name        = params[:message][:last_name]
    #   taxpayer.email            = params[:message][:email]
    #   taxpayer.phone_number     = params[:message][:phone_number]
    # end
    # @taxpayer.save
    @message.save
    ClientMailer.contact_form(current_agent).deliver_now
    redirect_to root_url, notice: 'Thanks for Contacting Us!'
  end

  private

  def message_params
    params.require(:message).permit([:first_name, :last_name, :email, :phone_number, :message])
  end

end
