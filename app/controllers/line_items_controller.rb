class LineItemsController < ApplicationController
  before_action :set_cart, only: [ :create ]
  include CurrentCart
  def create
    product = Product.find(params[:product_id])
    @line_item = @cart.add_product(product)
    if @line_item.save
      respond_to do |format|
        format.turbo_stream { @current_item = @line_item }
        format.html { redirect_to store_index_url  }
      end
    else
      redirect_to store_index_path, alert: "Could not add this product."
    end
  end
end
