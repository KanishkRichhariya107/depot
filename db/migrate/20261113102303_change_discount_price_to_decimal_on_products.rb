class ChangeDiscountPriceToDecimalOnProducts < ActiveRecord::Migration[8.1]
  def up
    change_column :products, :discount_price, :decimal, precision: 8, scale: 2, using: "NULLIF(discount_price, '')::decimal"
  end

  def down
    change_column :products, :discount_price, :string
  end
end
