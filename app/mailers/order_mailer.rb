class OrderMailer < ApplicationMailer 
  default from: -> { Rails.application.credentials.dig(:smtp, :user_name) || "depot@example.com" }
  
  def received(order)
    @order = order

    mail to: order.email, subject: "Pragmatic Store Order Confirmation"
  end 

  def shipped(order)
    @order = order

    mail to: order.email, subject: "Pragmatic Store Order Shipped"
  end
end
