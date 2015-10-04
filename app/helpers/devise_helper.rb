module DeviseHelper
  def devise_error_messages! 
    html = ""

    return html if resource.errors.empty?

    errors_number = 0 

    saved_key = ""
    resource.errors.each do |key, value|
      if key != saved_key
        html << "This #{key} #{value}"
        errors_number += 1
      end
      saved_key = key
    end
    
    return html.html_safe
 end
end