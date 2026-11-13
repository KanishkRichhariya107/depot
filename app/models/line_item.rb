class LineItem < ApplicationRecord
  belongs_to :cart, optional: true
  belongs_to :order, optional: true
  belongs_to :product
  validates :product_id, uniqueness: { scope: :cart_id }
  def total_price
    product.price*quantity
  end
end
