class Order < ActiveRecord::Base
  belongs_to :agent
  belongs_to :taxpayer

  has_attached_file :document, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/images/:style/missing.png"
  validates_attachment :document, :content_type => { :content_type => %w(application/pdf application/msword application/vnd.openxmlformats-officedocument.wordprocessingml.document) }

  serialize :notification_params, Hash

  def paypal_url(return_path)
    Rails.logger.info("%%%%%%%%%%%%%%%%%%%%%%")
    Rails.logger.info(id)
    Rails.logger.info("%%%%%%%%%%%%%%%%%%%%%%")
    invoice_id = 1000 + id
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
