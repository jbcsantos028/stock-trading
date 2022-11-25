class TraderAccountApprovalMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.trader_account_approval_mailer.trader_account_approved.subject
  #
  def trader_account_approved
    trader = params[:trader]
    @greeting = "Hi #{trader.email}!"

    mail to: trader.email, subject: "Trader Account Approved"
  end
end
