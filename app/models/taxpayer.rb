class EmailValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless value =~ /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
      record.errors[attribute] << (options[:message] || "is not an email")
    end
  end
end

class Taxpayer < ActiveRecord::Base
  belongs_to :agent
  has_many :orders

  validates :first_name, presence: true
  validates :first_name, length: { in: 2..30 }
  validates :last_name, presence: true
  validates :last_name, length: { in: 2..30 }
  validates :phone_number, presence: true
  validates :phone_number, length: { is: 14 } 
  validates :sin, presence: true
  validates :sin, length: { is: 9 }
  validates :dob, presence: true
  validates :dob, length: { is: 10 }
  validates :email, presence: true
  validates :email, length: { in: 5..30 }

  def name_display
    if first_name || last_name
      "#{first_name} #{last_name}".strip
    else
      email
    end
  end
end
