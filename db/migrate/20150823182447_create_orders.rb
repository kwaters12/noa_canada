class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.references :agent, index: true
      t.references :taxpayer, index: true
      t.string :status
      t.string :pdf_path
      t.string :docusign_url
      t.datetime :purchased_at
      t.string :transaction_id
      t.text :notification_params

      t.timestamps null: false
    end
    
  end
end
