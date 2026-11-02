require 'test_helper'

class LineItemsControllerTest < ActionDispatch::IntegrationTest
  test "should create line_item" do
    assert_difference("LineItem.count") do
      post line_items_url params: { product_id: products(:pragprog).id }
    end
  end

  test "should create line_item via turbo-stream" do
    assert_difference("LineItem.count") do
      post line_items_url,
        params: { product_id: products(:pragprog).id },
        as: :turbo_stream
    end

    assert_response :success
    assert_match /<tr class = "line-item-highlight">/, @response.body
  end
end
