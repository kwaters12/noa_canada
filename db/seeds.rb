# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
100.times do 
  Brokerage.create(name: Faker::Company.name, postal_code: Faker::Address.postcode, address: Faker::Address.street_address, city: Faker::Address.city, province: Faker::Address.state_abbr, phone_number: Faker::PhoneNumber.cell_phone)
end

100.times do 
  SubBrokerage.create(name: Faker::Company.name, postal_code: Faker::Address.postcode, address: Faker::Address.street_address, city: Faker::Address.city, province: Faker::Address.state_abbr, phone_number: Faker::PhoneNumber.cell_phone)
end