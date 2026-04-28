class SupportRequestsController < ApplicationController
  def index
    @support_requests = SupportRequest.includes(order: { line_items: :product }).with_rich_text_response.order(created_at: :desc)
  end

  def update
    support_request = SupportRequest.find(params[:id])
    support_request.update!(response: support_request_params[:response])

    SupportRequestMailer.respond(support_request).deliver_now
    redirect_to support_requests_path, notice: "Response sent"
  end

  private

    def support_request_params
      params.require(:support_request).permit(:response)
    end
end
