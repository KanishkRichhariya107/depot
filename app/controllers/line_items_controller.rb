class LineItemsController < ApplicationController
  before_action :set_cart, only: [ :create ]
  include CurrentCart
  def create
    product = Product.find(params[:product_id])
    @line_item = @cart.add_product(product)
    if @line_item.save
      redirect_to @line_item.cart
    else
      redirect_to store_index_path, alert: "Could not add this product."
    end
  end
end
