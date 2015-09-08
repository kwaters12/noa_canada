class RegistrationsController < Devise::RegistrationsController
    # include Wicked::Wizard

    # steps :choose_type, :add_password

  def show
    @agent = Agent.find(params[:agent_id])
    
    render_wizard
  end

  def update
    @agent = current_agent
    if !@agent.password
      generated_password = Devise.friendly_token.first(8)
      @agent.password = generated_password
    end    
    @agent.update_attributes(agent_params)
    sign_in(@agent, bypass: true) # needed for devise
    render_wizard @agent
  end

  private

  def agent_params
    params.require(:agent).permit(:account_number, :agent_type, :designated_individual, :first_name, :is_admin, :last_name, :email, :license_number, :phone_number, :password, :password_confirmation)
  end

  def after_sign_up_path_for(resource)
    after_signup_path(:choose_type)
  end  

  # def create
 
  #   @agent = Agent.new agent_params
  #   @taxpayer = Taxpayer.new taxpayer_params
  #   if @agent.save
  #     @agent.skip_confirmation!
  #     # render :json=> agent.as_json(:auth_token=>agent.authentication_token, :email=>agent.email), :status=>201
  #     redirect_to after_signup_path(:choose_type, :agent_id => @agent.id)
  #   else
  #     warden.custom_failure!
  #     render :json=> agent.errors, :status=>422
  #   end
  # end

  # private
 
  # def agent_params
  #   params.require(:agent).permit(:account_number, :agent_type, :designated_individual, :first_name, :is_admin, :last_name, :email, :license_number, :phone_number)
  # end

  # def taxpayer_params

  # end

end