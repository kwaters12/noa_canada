class SubBrokerage < ActiveRecord::Base
  belongs_to :brokerage
  has_many :agents
end
