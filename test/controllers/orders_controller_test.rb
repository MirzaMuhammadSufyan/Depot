require "test_helper"

class OrdersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @order = orders(:one)
    login_as users(:one)
  end

  test "should get index" do
    get orders_url
    assert_response :success
  end

  test "should get new" do
    get new_order_url
    assert_redirected_to store_index_url
  end

  test "should create order" do
    post line_items_url, params: { product_id: products(:one).id }
    cart_id = LineItem.order(:id).last.cart_id

    assert_difference("Order.count") do
      post orders_url, params: { order: { address: @order.address, email: @order.email, name: @order.name, pay_type: @order.pay_type } }
    end

    assert_redirected_to store_index_url
    assert_nil Cart.find_by(id: cart_id)
    assert_equal 1, Order.last.line_items.count
  end

  test "should show validation errors when order is invalid" do
    post line_items_url, params: { product_id: products(:one).id }

    post orders_url, params: { order: { address: "", email: "", name: "", pay_type: "" } }

    assert_response :unprocessable_entity
    assert_select "#error_explanation"
  end

  test "should show order" do
    get order_url(@order)
    assert_response :success
  end

  test "should get edit" do
    get edit_order_url(@order)
    assert_response :success
  end

  test "should update order" do
    patch order_url(@order), params: { order: { address: @order.address, email: @order.email, name: @order.name, pay_type: @order.pay_type } }
    assert_redirected_to order_url(@order)
  end

  test "should destroy order" do
    assert_difference("Order.count", -1) do
      delete order_url(@order)
    end

    assert_redirected_to orders_url
  end
end
