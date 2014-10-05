class Product < ActiveRecord::Base
  def self.products_during(interval)
  # return a count of users over an internal of time
  Product.where("created_at > ?", interval).count
  end
end



# Revenue = orders_contents.quantity * products.price

# select price
# JOIN order_contents AND products
# ON order_contents.sku = products.sku


# OrderContent.joins("JOIN orders ON orders.order_id = order_contents.order_id").where('orders.when_placed > ?', 1.year.ago).select("quantity*current_price AS revenue")
