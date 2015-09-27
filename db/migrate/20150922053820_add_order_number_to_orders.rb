class AddOrderNumberToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :order_number, :string
    add_column :orders, :dropbox_url, :string
  end
end
