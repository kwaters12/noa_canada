class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :phone_number
      t.text :message
      t.references :taxpayer, index: true

      t.timestamps null: false
    end
    add_foreign_key :messages, :taxpayers
  end
end
