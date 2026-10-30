class LineItemsController < ApplicationController
  include CurrentCart
  before_action :set_cart, only: [ :create ]
  def create
    product = Product.find(params[:product_id])
    @line_item = @cart.line_items.build(product: product)
    if @line_item.save
      redirect_to @line_item.cart, notice: "Added to cart."
    else
      redirect_to store_index_path, alert: "Could not add this product."
    end
  end
end
