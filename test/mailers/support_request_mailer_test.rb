require "test_helper"

class SupportRequestMailerTest < ActionMailer::TestCase
  test "respond" do
    support_request = support_requests(:one)
    support_request.update!(response: "Thank you for contacting us.")

    mail = SupportRequestMailer.respond(support_request)

    assert_equal "Re: #{support_request.subject}", mail.subject
    assert_equal [ support_request.email ], mail.to
    assert_equal [ "support@example.com" ], mail.from

    assert_match "Thank you for contacting us.", mail.body.encoded
    assert_match support_request.body, mail.body.encoded
  end
end
