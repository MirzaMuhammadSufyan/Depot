require "test_helper"

class SupportRequestsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @support_request = support_requests(:one)
    login_as users(:one)
  end

  test "should get index" do
    get support_requests_url
    assert_response :success
  end

  test "should redirect index when not authenticated" do
    delete session_url

    get support_requests_url
    assert_redirected_to new_session_url
  end

  test "should update support request and send response" do
    assert_emails 1 do
      patch support_request_url(@support_request), params: {
        support_request: {
          response: "<div>We found your order.</div>"
        }
      }
    end

    assert_redirected_to support_requests_url
    assert_equal "We found your order.", @support_request.reload.response.to_plain_text.strip
  end
end
