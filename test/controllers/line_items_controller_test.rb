require 'test_helper'

class LineItemsControllerTest < ActionDispatch::IntegrationTest
  test "should create line_item" do 
    assert_difference("LineItem.count") do
      post line_items_url params: { product_id: products(:pragprog).id }
    end
    follow_redirect!
  end
end
