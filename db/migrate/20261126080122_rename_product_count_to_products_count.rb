class RenameProductCountToProductsCount < ActiveRecord::Migration[8.1]
  def change
    rename_column :categories, :product_count, :products_count
  end
end
