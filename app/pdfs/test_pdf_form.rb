# class TestPdfForm < FillablePdfForm
#   def initialize(user)
#     @noa_application = noa_application
#     super()
#   end

#   protected

#   def fill_out
#     fill :date, Date.today.to_s
#     [:first_name, :last_name, :address, :address_2, :city, :state, :zip_code].each do |field|
#       fill_field, @noa_application.send(field)
#     end
#     fill :comments, "Hello World"
#   end
# end
