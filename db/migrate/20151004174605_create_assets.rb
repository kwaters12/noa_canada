class CreateAssets < ActiveRecord::Migration
  def change
    create_table :assets do |t|
      t.attachment :document
      t.references :order, index: true
      t.string :pdf_path

      t.timestamps null: false
    end
    add_foreign_key :assets, :orders
  end
end
