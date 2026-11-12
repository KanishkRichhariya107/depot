class AddPriceToLineItems < ActiveRecord::Migration[8.1]
  def up
    add_column :line_items, :price, :decimal,
               precision: 8, scale: 2

    execute <<~SQL
      UPDATE line_items
      SET price = products.price
      FROM products
      WHERE products.id = line_items.product_id
    SQL
  end

  def down
    remove_column :line_items, :price
  end
end
