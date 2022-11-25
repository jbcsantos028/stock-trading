# Preview all emails at http://localhost:3000/rails/mailers/trader_account_approval_mailer
class TraderAccountApprovalMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/trader_account_approval_mailer/trader_account_approved
  def trader_account_approved
    TraderAccountApprovalMailer.with(trader: User.first).trader_account_approved
  end

end
