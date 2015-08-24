class CreateBrokerages < ActiveRecord::Migration
  def change
    create_table :brokerages do |t|
      t.string :name
      t.string :postal_code
      t.string :address
      t.string :city
      t.string :province
      t.string :phone_number

      t.timestamps null: false
    end
  end
end
