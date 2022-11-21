class User < ApplicationRecord
  
  has_many :transactions
  has_many :stocks, through: :transactions

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
