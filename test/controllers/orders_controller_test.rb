require "test_helper"

class OrdersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @order = orders(:one)
    login_as users(:one)
  end

  test "requires item in cart" do
    get new_order_url

    assert_redirected_to store_index_url
    assert_equal "Your cart is empty", flash[:notice]
  end

  test "should get new" do
    post line_items_url,
    params: { product_id: products(:pragprog).id }
    get new_order_url
    assert_response :success
  end
  test "should crete order" do
    assert_difference("Order.count") do
      post orders_url, params: {
        order: {
          address: "123 Test Street",
          email: "test@example.com",
          name: "Test Customer",
          pay_type: "Check"
        }
      }
    end
    assert_redirected_to store_index_url(locale: "en")
  end
end
