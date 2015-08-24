class CreateSubBrokerages < ActiveRecord::Migration
  def change
    create_table :sub_brokerages do |t|
      t.string :name
      t.string :postal_code
      t.string :address
      t.string :city
      t.string :province
      t.string :phone_number
      t.references :brokerage, index: true

      t.timestamps null: false
    end
    add_foreign_key :sub_brokerages, :brokerages
  end
end
