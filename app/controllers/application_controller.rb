class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :configure_permitted_parameters, if: :devise_controller?

  def current_order
    if session[:order_id]
      @current_order ||= Order.find(session[:order_id])
      session[:order_id] = nil if @current_order.purchased_at
    end
    if session[:order_id].nil?
      @current_order = Order.create!
      session[:order_id] = @current_order.id
    end
    @current_order
  end

  private

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) {|u| u.permit(:account_number, :agent_type, :designated_individual, :first_name, :is_admin, :last_name, :email, :license_number, :phone_number, :brokerage_name, :sub_brokerage_name, :brokerage_id, :current_password)}
    devise_parameter_sanitizer.for(:account_update) {|u| u.permit(:account_number, :agent_type, :designated_individual, :first_name, :is_admin, :last_name, :email, :license_number, :phone_number, :brokerage_name, :sub_brokerage_name, :brokerage_id, :current_password)}
  end
end
