class ProductsChannel < ApplicationCable::Channel
  def subscribed
    stream_from "store/products"
  end
end
