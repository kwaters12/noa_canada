class ConfirmationsController < Devise::ConfirmationsController
  # Remove the first skip_before_filter (:require_no_authentication) if you
  # don't want to enable logged Agents to access the confirmation page.
  skip_before_filter :require_no_authentication
  skip_before_filter :authenticate_agent!

  # PUT /resource/confirmation
  def update

    @agent = current_agent    
    sign_in(@agent, bypass: true) if @agent == current_agent # needed for devise
    permitted = params.require(:agent).permit(:password, :password_confirmation)
    p = permitted[:password]
    c = permitted[:password_confirmation]

    Rails.logger.info("$$$$$$$$$$$$$$$$$")
    Rails.logger.info(p)
    Rails.logger.info(c)
    Rails.logger.info("%%%%%%%%%%%%%%%%%%%%")
    if (p === '')
      redirect_to root_url, notice: "Please Choose a Password"
    elsif (p != c)
      redirect_to root_url, notice: "Please Confirm Your Password"
    else
      @agent.update_attributes(agent_params)
      sign_in(@agent, bypass: true) if @agent == current_agent # needed for devise
      redirect_to root_url, notice: "Password Added"
    end
    # with_unconfirmed_confirmable do
    #   if @confirmable.has_no_password?
    #     @confirmable.attempt_set_password(params[:agent])
    #     if @confirmable.valid? and @confirmable.password_match?
    #       do_confirm
    #     else
    #       do_show
    #       @confirmable.errors.clear #so that we wont render :new
    #     end
    #   else
    #     self.class.add_error_on(self, :email, :password_already_set)
    #   end
    # end

    # if !@confirmable.errors.empty?
    #   render 'devise/confirmations/new' #Change this if you don't have the views on default path
    # end
  end

  # GET /resource/confirmation?confirmation_token=abcdef
  def show
    with_unconfirmed_confirmable do
      if @confirmable.has_no_password?
        do_show
      else
        do_confirm
      end
    end
    if !@confirmable.errors.empty?
      self.resource = @confirmable
      render 'devise/confirmations/new' #Change this if you don't have the views on default path 
    end
  end

  protected

  def agent_params
    params.require(:agent).permit(:account_number, :agent_type, :designated_individual, :first_name, :is_admin, :last_name, :email, :license_number, :phone_number, :password, :password_confirmation)
  end

  def with_unconfirmed_confirmable
    original_token = params[:confirmation_token]
    confirmation_token = Devise.token_generator.digest(Agent, :confirmation_token, original_token)
    @confirmable = Agent.find_or_initialize_with_error_by(:confirmation_token, confirmation_token)
    if !@confirmable.new_record?
      @confirmable.only_if_unconfirmed {yield}
    end
  end

  def do_show
    @confirmation_token = params[:confirmation_token]
    @requires_password = true
    self.resource = @confirmable
    render 'devise/confirmations/show' #Change this if you don't have the views on default path
  end

  def do_confirm
    @confirmable.confirm!
    set_flash_message :notice, :confirmed
    sign_in_and_redirect(resource_name, @confirmable)
  end
end