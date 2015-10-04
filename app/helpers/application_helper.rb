module ApplicationHelper

   def resource_name
    :agent
  end

  def resource
    @resource ||= Agent.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:agent]
  end
end
