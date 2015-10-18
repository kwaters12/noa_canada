class Agent < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable

  attr_accessor :form_step

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :phone_number, presence: true
  validates :phone_number, length: { is: 14 }
  # validates :license_number, presence: true, if: -> { required_for_step?(:choose_type)}
  # validates :sub_brokerage_name, presence: true, if: -> { required_for_step?(:choose_type)}
  validates :email, uniqueness: true
  belongs_to :sub_brokerage
  belongs_to :brokerage
  has_many :taxpayers
  has_many :orders
  has_many :messages

  require 'securerandom'

  def send_on_create_confirmation_instructions
    
  end

  def current_admin
    current_user && is_admin
  end

  def name_display
    if first_name || last_name
      "#{first_name} #{last_name}".strip
    else
      email
    end
  end



  def password_required?
    super if confirmed?
  end

  def password_match?
    self.errors[:password] << "can't be blank" if password.blank?
    self.errors[:password_confirmation] << "can't be blank" if password_confirmation.blank?
    self.errors[:password_confirmation] << "does not match password" if password != password_confirmation
    password == password_confirmation && !password.blank?
  end

  def only_if_unconfirmed
    pending_any_confirmation {yield}
  end

   def brokerage_name
    brokerage.try(:name)
  end

  def brokerage_name=(brokerage_name)
    self.brokerage = Brokerage.find_or_create_by(name: brokerage_name) if brokerage_name.present?
  end

  def sub_brokerage_name
    sub_brokerage.try(:name)
  end

  def sub_brokerage_name=(sub_brokerage_name)
    self.sub_brokerage = SubBrokerage.find_or_create_by(name: sub_brokerage_name) if sub_brokerage_name.present?
  end
end
