class CreateTaxpayers < ActiveRecord::Migration
  def change
    create_table :taxpayers do |t|
      t.string :first_name
      t.string :last_name
      t.string :sin
      t.string :dob
      t.string :email
      t.string :phone_number
      t.string :pdf_path
      t.references :agent, index: true

      t.timestamps null: false
    end
    add_foreign_key :taxpayers, :agents
  end
end
