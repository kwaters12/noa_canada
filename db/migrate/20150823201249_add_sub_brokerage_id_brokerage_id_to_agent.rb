class AddSubBrokerageIdBrokerageIdToAgent < ActiveRecord::Migration
  def change
    add_reference :agents, :sub_brokerage, index: true
    add_foreign_key :agents, :sub_brokerages
    add_reference :agents, :brokerage, index: true
    add_foreign_key :agents, :brokerages
  end
end
