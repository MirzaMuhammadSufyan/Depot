require "test_helper"

class SupportRequestMailerTest < ActionMailer::TestCase
  test "respond" do
    support_request = support_requests(:one)
    support_request.update!(response: "<div><strong>We found it.</strong></div>")

    mail = SupportRequestMailer.respond(support_request)

    assert_equal "Re: Missing order", mail.subject
    assert_equal [ "dave@example.org" ], mail.to
    assert_equal [ "support@example.com" ], mail.from
    assert_includes mail.text_part.body.to_s, "We found it."
    assert_includes mail.html_part.body.to_s, "We found it."
    assert_includes mail.body.encoded, support_request.body
  end
end
