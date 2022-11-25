require "test_helper"

class TraderAccountApprovalMailerTest < ActionMailer::TestCase
  test "trader_account_approved" do
    mail = TraderAccountApprovalMailer.trader_account_approved
    assert_equal "Trader account approved", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
