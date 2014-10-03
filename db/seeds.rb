# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

SCALAR = 5

#generate products
SCALAR.times do
  sample_category = Faker::Commerce.department
  SCALAR.times do
  end
end

#generate addresses, SCALAR+SCALAR^2+SCALAR^3 cities
def sample_city
  {"city" => Faker::Address.city, "state" => Faker::Address.state, "zip" => (Faker::Address.zip_code).to_i}
end

def sample_cities
  cities, towns, villages = [], [], []
  SCALAR.times do
    cities << sample_city
    SCALAR.times do
      towns << sample_city
      SCALAR.times do
        villages << sample_city
      end
    end
  end
  [cities, towns, villages]
end

SAMPLECITIES = sample_cities

def generate_addresses(user_id)
  (rand(6)).times do
    city_instance = SAMPLECITIES.sample.sample
    a = Address.new({user_id: user_id, street_address: Faker::Address.street_address, city: city_instance["city"], state: city_instance["state"], zip: Faker::Address.zip_code.to_i})
    a.save
  end
  address_choices = (Address.select(:id).where(:user_id => user_id)).to_a
  address_choices[0] ? [address_choices.sample[:id], address_choices.sample[:id]] : [nil, nil]
end

#generate users, 100 users
(20*SCALAR).times do |x|
  sample_name = Faker::Name.name
  address_samples = generate_addresses(x+1)

  u = User.new({id: x+1, name: sample_name, email: Faker::Internet.email(sample_name), phone_number: Faker::PhoneNumber.phone_number, default_billing_address: address_samples[0], default_shipping_address: address_samples[1]})

  u.save
end

def creation_date

end

#generate orders

#generate order contents
