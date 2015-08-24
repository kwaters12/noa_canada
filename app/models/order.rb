class Order < ActiveRecord::Base
  belongs_to :agent
  belongs_to :taxpayer
end
