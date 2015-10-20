if Rails.env == "development"
  ActiveMerchant::Billing::FirstdataE4Gateway.wiredump_device = File.open(Rails.root.join("log","active_merchant.log"), "a+")  
  ActiveMerchant::Billing::FirstdataE4Gateway.wiredump_device.sync = true 
  ActiveMerchant::Billing::Base.mode = :test

  login = Rails.application.secrets.payment_login
  password= Rails.application.secrets.payment_password
elsif Rails.env == "production"
  login = Rails.application.secrets.payment_login
  password= Rails.application.secrets.payment_password
end
GATEWAY = ActiveMerchant::Billing::FirstdataE4Gateway.new({
      login: login,
      password: password
})