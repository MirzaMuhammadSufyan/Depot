class SupportMailbox < ApplicationMailbox
  def process
    SupportRequest.create!(
      email: sender_email,
      subject: mail.subject,
      body: mail.body.to_s,
      order: recent_order
    )
  end

  private

    def sender_email
      mail.from_address.to_s
    end

    def recent_order
      Order.where(email: sender_email).order(created_at: :desc).first
    end
end
