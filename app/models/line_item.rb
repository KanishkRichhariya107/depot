class LineItem < ApplicationRecord
  belongs_to :cart, optional: true, counter_cache: true
  belongs_to :order, optional: true
  belongs_to :product
  validates :product_id, uniqueness: { scope: :cart_id }, if: -> { cart_id.present? }
  def total_price
    product.price*quantity
  end
end
