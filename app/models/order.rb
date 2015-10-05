class Order < ActiveRecord::Base
  belongs_to :agent
  belongs_to :taxpayer
  has_many :assets

  accepts_nested_attributes_for :assets, :reject_if => :all_blank, :allow_destroy => true

  serialize :notification_params, Hash

  def order_number 
    100000 + "#{id}".to_i
  end

  def paypal_url(return_path)
    Rails.logger.info("%%%%%%%%%%%%%%%%%%%%%%")
    Rails.logger.info(id)
    Rails.logger.info("%%%%%%%%%%%%%%%%%%%%%%")
    invoice_id = 10000 + id
    values = {
        business: "kellywaters-facilitator@gmail.com",
        cmd: "_xclick",
        upload: 1,
        return: "#{Rails.application.secrets.app_host}#{return_path}",
        invoice: invoice_id,
        amount: 50,
        item_name: "NOA Canada - Order",
        item_number: 1,
        quantity: '1',
        notify_url: "#{Rails.application.secrets.app_host}hook"
    }
    "https://www.sandbox.paypal.com/cgi-bin/webscr?" + values.to_query
  end 

end
