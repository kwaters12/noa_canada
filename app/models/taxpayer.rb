class Taxpayer < ActiveRecord::Base
  belongs_to :agent
  has_many :orders
end
