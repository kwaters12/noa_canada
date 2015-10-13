class CreatePaymentNotifications < ActiveRecord::Migration
  def change
    create_table :payment_notifications do |t|
      t.text :params
      t.references :order
      t.string :status
      t.string :transaction_id

      t.timestamps null: false
    end
  end
end
