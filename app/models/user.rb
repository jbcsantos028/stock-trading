class User < ApplicationRecord
  
  has_many :user_stocks
  has_many :stocks, through: :user_stocks

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def stock_already_owned?(symbol)
    stock = Stock.check_db(symbol)
    return false unless stock
    stocks.where(id: stock.id).exists?
  end
  
end
