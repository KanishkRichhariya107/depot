class ChangeDiscountPriceToStringOnProducts < ActiveRecord::Migration[8.1]
  def change
    change_column :products, :discount_price, :string
  end
end
