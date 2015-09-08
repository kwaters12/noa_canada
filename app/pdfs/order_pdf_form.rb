class OrderPDFForm < FillablePdfForm
  def initialize(taxpayer)
    @taxpayer = taxpayer
    super()
  end

  protected

  def fill_out
    fill :date, Date.today.to_s.gsub(/\//, '')
    [:sin, :first_name, :last_name, :dob].each do |field|
      fill field, @taxpayer.send(field)
    end
  end
end