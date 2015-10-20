class AddOrderNumberToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :order_number, :string
    add_column :orders, :dropbox_url, :string
    add_column :orders, :order_type, :string
    add_column :orders, :payment_method, :string
    add_column :orders, :payment_confirmation_number, :string
    add_column :orders, :ip, :string
    add_column :orders, :last4, :string
    add_column :orders, :amount, :decimal
    add_column :orders, :authorization_code, :string
  end
end
