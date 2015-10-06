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

  validates :first_name, length: { in: 1..30, message: 'Legal Name' }
  validates :last_name, length: { in: 1..30, message: 'Surname' }
  validates :phone_number, length: { is: 14, message: 'Area Code and Phone Number' }
  validates :sin, length: { is: 11, message: '9-Digit SIN Number' }
  validates :dob, length: { is: 10, message: 'YYYY/MM/DD' }
  validates_format_of :email, :with => /\b[A-Z0-9._%a-z\-]+@(?:[A-Z0-9a-z\-]+\.)+[A-Za-z]{2,4}\z/, :message => "Must be a Valid Email"

  # accepts_nested_attributes_for :orders

  def name_display
    if first_name || last_name
      "#{first_name} #{last_name}".strip
    else
      email
    end
  end

  # def username=(val)
  #   write_attribute(:username, val.downcase)
  # end

  # def dob=(val)
  #   write_attribute(:dob, val.gsub(/\/\//, ""))
  # end

  # def sin=(val)
  #   write_attribute(:sin, val.gsub(/\s+/, ""))
  # end
end
