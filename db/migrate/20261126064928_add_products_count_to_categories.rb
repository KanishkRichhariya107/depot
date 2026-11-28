class AddProductsCountToCategories < ActiveRecord::Migration[8.1]
  def change
    add_column :categories, :products_count, :integer, default: 0, null: false
  end
end
