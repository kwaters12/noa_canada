class AfterSignupController < ApplicationController
  include Wicked::Wizard

  steps :choose_type

   def show
    @agent = current_agent
    render_wizard
  end

  def update
    @agent = current_agent
    case params[:agent][:agent_type]
    when "None"
      @taxpayer = Taxpayer.new(first_name: @agent.first_name, last_name: @agent.last_name, email: @agent.email, phone_number: @agent.phone_number)
      @taxpayer.save      
      @agent.destroy     
      redirect_to root_url, notice: "An NOACanada.ca representative will be in contact shortly."
    else 
      @agent.update_attributes(agent_params)
      sign_in(@agent, bypass: true) # needed for devise
      render_wizard @agent
    end

  end

  def choose_type
    @agent = current_agent
    if !agent 
      redirect_to root_url
    end
  end

  private

  def agent_params
    params.require(:agent).permit(:account_number, :agent_type, :designated_individual, :first_name, :is_admin, :last_name, :email, :license_number, :phone_number, :brokerage_name, :sub_brokerage_name, :brokerage_id, :sub_brokerage_id)
  end

  def taxpayer_params
    params.require(:agent).permit(:first_name, :last_name, :email, :phone_num)
  end

end
