class RegistrationsController < Devise::RegistrationsController

  before_action :check_errors
  # before_filter :configure_permitted_parameters

  def show
    @agent = Agent.find(params[:agent_id])
    
    render_wizard
  end

  def update

    @agent = current_agent
    Rails.logger.info("DSFFDSFDSFD")
    Rails.logger.info(params[:account_confirmed])
    Rails.logger.info("DSFFDSFDSFD")
    if params[:account_confirmed]
      ClientMailer.welcome_email(current_agent).deliver_now
    end
    if !@agent.password
      generated_password = Devise.friendly_token.first(8)
      @agent.password = generated_password
    end    
    if  @agent.update_attributes(agent_params)
      sign_in(@agent, bypass: true) # needed for devise
      redirect_to root_url, notice: "Account Changes Saved Successfully"
    else 
      redirect_to root_url, notice: "Login Failed"
    end

  end

  def check_errors
    if @agent
      flash[:notice] = flash[:notice].to_a.concat @agent.errors.full_messages
    end
  end

  # def create 
  #   @agent = Agent.new agent_params
  #   # @taxpayer = Taxpayer.new taxpayer_params
  #   if @agent.save
  #     @agent.skip_confirmation!
  #     # render :json=> agent.as_json(:auth_token=>agent.authentication_token, :email=>agent.email), :status=>201
  #     redirect_to after_signup_path(:choose_type, :agent_id => @agent.id)
  #   else
  #     warden.custom_failure!
  #     render :json=> @agent.errors, :status=>422
  #   end
  # end

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up).push(:account_number, :agent_type, :designated_individual, :first_name, :is_admin, :last_name, :email, :license_number, :phone_number, :brokerage_name, :sub_brokerage_name, :brokerage_id, :office_phone_number)
    devise_parameter_sanitizer.for(:account_update).push(:account_number, :agent_type, :designated_individual, :first_name, :is_admin, :last_name, :email, :license_number, :phone_number, :brokerage_name, :sub_brokerage_name, :brokerage_id, :office_phone_number)
  end

  private

  def agent_params
    params.require(:agent).permit(:account_number, :agent_type, :designated_individual, :first_name, :is_admin, :last_name, :email, :license_number, :phone_number, :password, :password_confirmation, :office_phone_number, :brokerage_name, :sub_brokerage_name)
  end

  def after_sign_up_path_for(resource)
    after_signup_path(:choose_type)
  end  

  

  # private
 
  # def agent_params
  #   params.require(:agent).permit(:account_number, :agent_type, :designated_individual, :first_name, :is_admin, :last_name, :email, :license_number, :phone_number)
  # end

  # def taxpayer_params

  # end

end