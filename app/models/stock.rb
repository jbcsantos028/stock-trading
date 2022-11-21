class Stock < ApplicationRecord
  has_many :user_stocks
  has_many :users, through: :user_stocks

  #add validations here

  def self.new_quote(stock_symbol)
    client = IEX::Api::Client.new(publishable_token: Rails.application.credentials.iex_client[:public_key],
                                  secret_token: Rails.application.credentials.iex_client[:secret_key],
                                  endpoint: 'https://cloud.iexapis.com/v1')
    begin
      new(symbol: stock_symbol, name: client.company(stock_symbol).company_name, latest_price: client.quote(stock_symbol).latest_price)
    rescue => exception
      return nil
    end
  end

  def self.check_db(symbol)
    where(symbol: symbol).first
  end
end
