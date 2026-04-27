require "test_helper"

class OrderMailerTest < ActionMailer::TestCase
  test "received" do
    order = orders(:one)
    mail = OrderMailer.received(order)

    assert_equal "Pragmatic Store Order Confirmation", mail.subject
    assert_equal [ order.email ], mail.to
    assert_equal [ "depot@example.com" ], mail.from
    assert_match order.name, mail.body.encoded
  end

  test "shipped" do
    order = orders(:one)
    mail = OrderMailer.shipped(order)

    assert_equal "Pragmatic Store Order Shipped", mail.subject
    assert_equal [ order.email ], mail.to
    assert_equal [ "depot@example.com" ], mail.from
    assert_match "Pragmatic Order Shipped", mail.body.encoded
  end
end
