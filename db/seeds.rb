# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


########################################

# wrapper methods to allow us to swap out
# the Faker gem in the future, if required

def random_state
  Faker::Address.state
end

def random_city
  Faker::Address.city
end

def random_first_name
  Faker::Name.first_name
end

def random_last_name
  Faker::Name.last_name
end

def random_email_address(first_name)
  email_type = rand(0..2)

  case email_type
  when 0
    Faker::Internet.unique.email(first_name)
  when 1
    Faker::Internet.unique.free_email(first_name)
  when 2
    Faker::Internet.unique.safe_email(first_name)
  end
end

def random_password(min_length = 12, max_length = 16)
  Faker::Internet.password(min_length, max_length)
end

def random_street_address
  coin_flip = rand(0..1)

  if coin_flip == 0
    Faker::Address.street_address
  else
    "#{Faker::Address.street_address} #{Faker::Address.secondary_address}"
  end
end

def random_zipcode
  Faker::Address.zip_code
end

def random_phone_number
  Faker::PhoneNumber.phone_number
end

def random_credit_card_number
  Faker::Business.credit_card_number
end

def random_credit_card_expiry_date
  Faker::Business.credit_card_expiry_date
end

def random_product_category_name
  Faker::Commerce.department
end

def random_product_category_description
  Faker::Lorem.sentence
end

def random_product_name
  "#{Faker::Commerce.product_name}, #{Faker::Commerce.color}"
end

def random_product_description
  Faker::Lorem.sentence
end

def random_product_sku(name)
  "#{name[0..2].upcase}#{Faker::Number.number(4)}"
end

# generates a random Product price in cents.
def random_product_price(min_price = 100, max_price = 10000)
  Faker::Number.between(min_price, max_price)
end

def random_product_stock(min_stock = 1, max_stock = 1000)
  Faker::Number.between(min_stock, max_stock)
end

def random_quantity(min_qty = 1, max_qty = 100)
  Faker::Number.between(min_qty, max_qty)
end

########################################

# Helper methods

# deletes all data in the database
def delete_all_data_in_db
  ShoppingCartProduct.delete_all
  OrderProduct.delete_all
  ShoppingCart.delete_all
  Order.delete_all
  Product.delete_all
  ProductCategory.delete_all

  CreditCard.delete_all
  User.delete_all
  Address.delete_all
  AddressType.delete_all
  City.delete_all
  State.delete_all
  Country.delete_all
end

# gets ids of all instances of the Model that are
# already persisted to the DB.
def get_ids(model)
  model.all.map { |instance| instance.id }
end

# returns an Array of intervals length, where each element is
# the number of Model instances that we want to create over time.
# Each element is >= the element before it, to simulate an
# increase over time.
def instances_over_time(initial = 5, intervals = 12, min_increment = 0, max_increment = 2, multiplier = 1)
  instances = []
  current_num = initial

  instances.push(current_num)
  (intervals - 1).times do
    increment = (rand(min_increment..max_increment) * multiplier).ceil
    current_num += increment
    instances.push(current_num)
  end

  instances
end

# generates a date months_ago months ago (with some variance
# in days / hours / minutes / seconds), to allow us to simulate
# Users signing up and Orders being placed in the past
def generate_past_date(months_ago)
  days_variance = rand(-7..7)
  hours_variance = rand(0..12)
  minutes_variance = rand(0..60)
  seconds_variance = rand(0..60)

  Time.now - months_ago.months + days_variance.days + hours_variance.hours + minutes_variance.minutes + seconds_variance.seconds
end

########################################

# create the Country model object
# we're assuming that we only have one Country, the USA
def create_country
  country = Country.new(name: "United States of America")
  if country.save
    puts "The Country: #{country.name} was created."
  else
    puts "Error creating Country model instance."
  end
end

# create 5 to 10 random State objects
# unaffected by seed multipler
def create_states
  country_id = Country.first.id
  num_states = rand(5..10)

  num_states.times do
    state = State.new(name: random_state, country_id: country_id)

    if state.save
      puts "The State: #{state.name} was created."
    else
      puts "Error creating State model instance."
    end
  end
end

# create at least 100 random City objects
# affected by seed multiplier
def create_cities(seed_multiplier = 1)
  state_ids = State.all.map { |state| state.id }

  # # determine a random number of Cities to create, with some variance
  num_cities = ((100 + rand(0..10)) * seed_multiplier).ceil

  num_cities.times do
    city = City.new(name: random_city, state_id: state_ids.sample)

    if city.save
      puts "The City: #{city.name} with state_id: #{city.state_id} was created."
    else
      puts "Error creating City model instance."
    end
  end
end

# creates 2 AddressType model instances: "Billing" and "Shipping"
def create_address_types
  billing = AddressType.new(address_type: "Billing")
  if billing.save
    puts "The AddressType: #{billing.address_type} was created."
  else
    puts "Error creating Billing AddressType."
  end

  shipping = AddressType.new(address_type: "Shipping")
  if shipping.save
    puts "The AddressType: #{shipping.address_type} was created."
  else
    puts "Error creating Shipping AddressType."
  end
end

# creates a single User model instance
def create_user
  first_name = random_first_name

  user = User.new(
    first_name: first_name,
    last_name: random_first_name,
    password: random_password,
    email_address: random_email_address(first_name)
  )

  if user.save
    puts "The User: #{user.first_name} #{user.last_name} was created."
  else
    puts "Error creating User model instance."
  end

  user
end

# modifies the User's created_at attribute to a date
# in the past to simulate him signing up then
def modify_signup_date(user, months_ago)
  user.created_at = generate_past_date(months_ago)

  if user.save
    puts "Modified User with id: #{user.id}, created_at date is now: #{user.created_at}."
  else
    puts "Error modifying User created_at date."
  end

  user
end

# creates a random number of User model instances.
# each User's created_at date is adjusted to give
# the impression of more Users joining over time.
def create_users
  num_users_per_month = instances_over_time
  months_ago = 12

  num_users_per_month.each do |user_count|
    user_count.times do
      user = create_user
      modify_signup_date(user, months_ago)
    end

    puts "Created #{user_count} Users."
    months_ago -= 1
  end
end

# creates a single Address for a User.
def create_address(user, city_id, state_id, country_id, address_type_id)
  address = Address.new(
    street_address: random_street_address,
    city_id: city_id,
    state_id: state_id,
    country_id: country_id,
    zipcode: random_zipcode,
    phone_number: random_phone_number,
    address_type_id: address_type_id,
    user_id: user.id
  )

  if address.save
    puts "The Address with id: #{address.id} was created for User with id: #{user.id}."
  else
    puts "Error creating Address model instance."
  end
end

# creates 0 to 5 Addresses per User.
def create_addresses(users)
  country_ids = get_ids(Country)
  state_ids = get_ids(State)
  city_ids = get_ids(City)
  address_type_ids = get_ids(AddressType)

  users.each do |user|
    num_addresses = rand(0..5)

    num_addresses.times do
      create_address(
        user,
        city_ids.sample,
        state_ids.sample,
        country_ids.sample,
        address_type_ids.sample
      )
    end
  end
end

# Returns the id of the appropriate AddressType model object.
def get_address_type_id(address_type)
  AddressType.find_by(address_type: address_type).id
end

# sets the User's default Address for each AddressType ("Billing" or "Shipping"), if at least one exists
def set_default_address(user, address_type)
  address = Address.find_by(user_id: user.id, address_type_id: get_address_type_id(address_type))

  unless address.nil?
    case address_type
    when "Billing"
      user.default_billing_address_id = address.id

      if user.save
        puts "User with id: #{user.id}'s default billing address set to Address with id: #{address.id}"
      else
        puts "Error when setting User with id: #{user.id}'s default billing address."
      end
    when "Shipping"
      user.default_shipping_address_id = address.id

      if user.save
        puts "User with id: #{user.id}'s default shipping address set to Address with id: #{address.id}"
      else
        puts "Error when setting User with id: #{user.id}'s default shipping address."
      end
    end
  end
end

# sets default billing and shipping Addresses for all Users
def set_default_addresses(users)
  users.each do |user|
    set_default_address(user, "Billing")
    set_default_address(user, "Shipping")
  end
end

# creates a Credit Card model instance for a single User.
def create_credit_card(user)
  credit_card = CreditCard.new(
    card_number: random_credit_card_number,
    expiry_date: random_credit_card_expiry_date,
    user_id: user.id
  )

  if credit_card.save
    puts "CreditCard created for User with id: #{credit_card.user_id}."
  else
    puts "Error creating CreditCard for User with id: #{user.id}."
  end

  credit_card
end

# creates a random CreditCard model object, for all
# Users that have a default billing Address
def create_credit_cards
  users_with_billing_addresses = User.all.select { |user| !user.default_billing_address_id.nil? }

  users_with_billing_addresses.each { |user| create_credit_card(user) }
end

# creates a number of ProductCategory model instances.
def create_product_categories(num_categories = 6)
  num_categories.times do
    product_category = ProductCategory.new(
      name: random_product_category_name,
      description: random_product_category_description
    )

    if product_category.save
      puts "ProductCategory: #{product_category.name} created."
    else
      puts "Error creating ProductCategory."
    end
  end
end

# creates a single Product tied to a ProductCategory.
def create_product(product_category_id)
  product_name = random_product_name

  product = Product.new(
    name: product_name,
    description: random_product_description,
    sku: random_product_sku(product_name),
    price: random_product_price,
    stock: random_product_stock,
    product_category_id: product_category_id
  )

  if product.save
    puts "Product: #{product.name} created."
  else
    puts "Error creating Product."
  end
end

# creates a random number of Product model instances.
def create_products(min = 10, max = 30)
  num_products = rand(min..max)
  product_category_ids = get_ids(ProductCategory)

  num_products.times do
    create_product(product_category_ids.sample)
  end
end

# creates an initial Order object for a single User.
def create_order(user)
  order = Order.new(
    user_id: user.id,
    billing_address_id: user.default_billing_address_id,
    shipping_address_id: user.default_shipping_address_id
  )

  if order.save
    puts "Order id: #{order.id} created."
  else
    puts "Error creating Order."
  end

  order
end

# modifies the created_at attribute of a particular Order,
# to simulate that Order being placed in the past.
def modify_placed_date(order, months_ago)
  order.created_at = generate_past_date(months_ago)

  if order.save
    puts "Order id: #{order.id}'s created_at date modified to: #{order.created_at}"
  else
    puts "Error modifying Order created_at date."
  end
end

# modifies the shipping_date of a particular Order, sets it
# from 1 to 7 days ahead of its created_at date.
def modify_shipping_date(order)
  order.shipping_date = order.created_at + rand(1..7).days

  if order.save
    puts "Order id: #{order.id}'s shipping date modified to: #{order.shipping_date}"
  else
    puts "Error modifying Order shipping_date."
  end
end

# checks whether an Order was shipped before the current time,
# and if so, sets the Order as fulfilled.
def set_fulfilled(order)
  if order.shipping_date < Time.now
    order.fulfilled = true
  end

  if order.save
    puts "Order id: #{order.id} set as fulfilled."
  else
    puts "Error modifying Order fulfilled attribute."
  end
end

# creates Orders for Users with both billing and shipping Addresses.
# Orders are created in increasing quantities over time, for random Users.
def create_orders
  users_with_both_addresses = User.all.select { |user| !user.default_billing_address_id.nil? && !user.default_shipping_address_id.nil? }

  num_orders_per_month = instances_over_time
  months_ago = 12

  num_orders_per_month.each do |order_count|
    order_count.times do
      user = users_with_both_addresses.sample

      order = create_order(user)
      modify_placed_date(order, months_ago)
      modify_shipping_date(order)
      set_fulfilled(order)
    end

    puts "Created #{order_count} Orders."
    months_ago -= 1
  end
end

# creates a number of OrderProducts - Products in each Order tied to a User.
def create_order_products(min_products_in_order = 1, max_products_in_order = 20)
  order_ids = get_ids(Order)
  product_ids = get_ids(Product)

  order_ids.each do |order_id|
    order = Order.find(order_id)

    rand(min_products_in_order..max_products_in_order).times do
      order_product = OrderProduct.new(
        order_id: order_id,
        product_id: product_ids.sample,
        quantity: random_quantity,
        created_at: order.created_at
      )

      if order_product.save
        puts "OrderProduct for Order id: #{order_product.order_id}, Product id: #{order_product.product_id} created."
      else
        puts "Error creating OrderProduct."
      end
    end
  end
end

# seeds the database with test data
def seed_database
  delete_all_data_in_db

  create_country
  create_states
  create_cities

  create_address_types
  create_users

  users = User.all
  create_addresses(users)
  set_default_addresses(users)

  create_credit_cards

  create_product_categories
  create_products
  create_orders
  create_order_products
end

seed_database
