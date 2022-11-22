class Stock < ApplicationRecord
  has_many :transactions
  has_many :users, through: :transactions

  #add validations here

  def self.new_quote(stock_symbol)
    client = IEX::Api::Client.new(publishable_token: Rails.application.credentials.iex_client[:public_key],
                                  secret_token: Rails.application.credentials.iex_client[:secret_key],
                                  endpoint: 'https://cloud.iexapis.com/v1') #initializer
    quote = client.quote(stock_symbol)

    begin
      new(symbol: stock_symbol, name: quote.company_name, latest_price: quote.latest_price)
    rescue
      return nil
    end

  end

  def self.check_db(symbol) #modify this // refer to NOTES
    where(symbol: symbol).first
  end
end
