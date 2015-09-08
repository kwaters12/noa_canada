class Taxpayer < ActiveRecord::Base
  belongs_to :agent
  has_many :orders

  def name_display
    if first_name || last_name
      "#{first_name} #{last_name}".strip
    else
      email
    end
  end
end
