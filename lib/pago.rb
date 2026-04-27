require "ostruct"

class Pago
  def self.make_payment(order_id:, payment_method:, payment_details:)
    case payment_method
    when :check
      Rails.logger.info "Processing check: #{payment_details.fetch(:routing)}/#{payment_details.fetch(:account)}"
    when :credit_card
      Rails.logger.info(
        "Processing credit_card: #{payment_details.fetch(:cc_num)}/" \
        "#{payment_details.fetch(:expiration_month)}/#{payment_details.fetch(:expiration_year)}"
      )
    when :po
      Rails.logger.info "Processing purchase order: #{payment_details.fetch(:po_num)}"
    else
      raise "Unknown payment_method #{payment_method}"
    end

    sleep 3 unless Rails.env.test?
    Rails.logger.info "Done Processing Payment for order #{order_id}"
    OpenStruct.new(succeeded?: true)
  end
end
