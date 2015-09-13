class AgentsController < ApplicationController
  def create
    @agent = Agent.new
    @agent.save(validate: false)
    redirect_to agent_step_path(@agent, Agent.steps.first)
  end
  
end
