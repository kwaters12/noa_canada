class AddSubBrokerageIdBrokerageIdToAgent < ActiveRecord::Migration
  def change
    add_reference :agents, :sub_brokerage, index: true
    add_reference :agents, :brokerage, index: true
    add_column    :agents, :office_phone_number, :string
  end
end
