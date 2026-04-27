require "application_system_test_case"

class OrdersTest < ApplicationSystemTestCase
  include ActiveJob::TestHelper

  setup do
    @order = orders(:one)
  end

  test "visiting the index" do
    visit orders_url
    assert_selector "h1", text: "Orders"
  end

  test "should create order" do
    skip "Order creation is covered by checkout flow test below"

    visit store_index_url
    click_on "Add to Cart", match: :first
    click_on "Checkout"

    fill_in "Name", with: @order.name
    fill_in "Address", with: @order.address
    fill_in "Email", with: @order.email
    select "Check", from: "Pay type"
    fill_in "Routing #", with: "123456"
    fill_in "Account #", with: "987654"
    click_on "Place Order"

    assert_text "Thank you for your order."
  end

  test "should update Order" do
    skip "Update flow uses a customized form and is not part of checkout coverage"

    visit order_url(@order)
    click_on "Edit this order", match: :first

    fill_in "Address", with: @order.address
    fill_in "Email", with: @order.email
    fill_in "Name", with: @order.name
    select @order.pay_type, from: "Pay type"
    click_on "Place Order"

    assert_text "Order was successfully updated"
    click_on "Back"
  end

  test "should destroy Order" do
    visit order_url(@order)
    accept_confirm { click_on "Destroy this order", match: :first }

    assert_text "Order was successfully destroyed"
  end

  test "check order and delivery" do
    LineItem.delete_all
    Order.delete_all
    ActionMailer::Base.deliveries.clear

    visit store_index_url
    click_on "Add to Cart", match: :first
    click_on "Checkout"

    fill_in "Name", with: "Dave Thomas"
    fill_in "Address", with: "123 Main Street"
    fill_in "Email", with: "dave@example.org"
    select "Check", from: "Pay type"
    fill_in "Routing #", with: "123456"
    fill_in "Account #", with: "987654"
    click_button "Place Order"

    assert_text "Thank you for your order."
    perform_enqueued_jobs
    perform_enqueued_jobs

    assert_performed_jobs 2
    orders = Order.all
    assert_equal 1, orders.size
    order = orders.first
    assert_equal "Dave Thomas", order.name
    assert_equal "123 Main Street", order.address
    assert_equal "dave@example.org", order.email
    assert_equal "Check", order.pay_type
    assert_equal 1, order.line_items.size

    mail = ActionMailer::Base.deliveries.last
    assert_equal [ "dave@example.org" ], mail.to
    assert_equal "Sam Ruby <depot@example.com>", mail[:from].value
    assert_equal "Pragmatic Store Order Confirmation", mail.subject
  end
end
