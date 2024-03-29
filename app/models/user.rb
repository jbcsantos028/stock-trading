class User < ApplicationRecord
  
  has_many :transactions
  has_many :stocks, through: :transactions
  has_many :transaction_records

  # Include default devise modules. Others available are:
  # :lockable, :timeoutable, :trackable and :omniauthable

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable

  def stock_already_owned?(symbol)
    stock = Stock.check_db(symbol)
    return false unless stock
    stocks.where(id: stock.id).exists?
  end
  
  def trader?
    !admin?
  end
  
end
