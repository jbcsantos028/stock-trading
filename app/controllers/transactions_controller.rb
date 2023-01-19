class TransactionsController < ApplicationController
  require 'bigdecimal/util'
  before_action :disallow_admin
  before_action :disallow_unapproved_trader, only: [:create, :edit, :update]
  before_action :require_stock_shares, only: [:create, :update]
  before_action :restrict_stock_selling, only: :update

  def index
    @owned_stocks = current_user.transactions
    render :my_portfolio
  end

  def create
    stock = Stock.check_db(transaction_params[:symbol]) #lines 14 to 18 can be done using find_or_create_by
    if stock.blank?
      stock = Stock.new_quote(transaction_params[:symbol])
      stock.save
    end
    
    @transaction = current_user.transactions.create(stock: stock, shares: transaction_params[:shares])
    @transaction_record = current_user.transaction_records.create(stock_symbol: stock.symbol, company_name: stock.name, shares: transaction_params[:shares], price: stock.latest_price, transaction_type: "buy")
    flash[:notice] = "Purchase successful!"
    redirect_to my_portfolio_path
  end

  def edit
    if params[:transaction_type_sell].present?
      @transaction_type_sell = params[:transaction_type_sell]
    end

    @owned_stock = Transaction.find(params[:id])
    @stock = @owned_stock.stock

    respond_to do |format|
      format.js { render partial: 'transactions/form' }
    end
    
  end

  def update
    @transaction = Transaction.find(params[:id])
    stock = @transaction.stock

    if params[:transaction_type_sell] == "True"
      updated_shares = @transaction.shares - transaction_params[:shares].to_d
      remove_stock_from_transactions(@transaction, stock, transaction_params[:shares]) if updated_shares == 0 
      transaction_type = "sell"
      flash_message = "Selling successful!"
    else
      updated_shares = @transaction.shares + transaction_params[:shares].to_d
      transaction_type = "buy"
      flash_message = "Purchase successful!"
    end
    
    begin
      @transaction.update(shares: updated_shares)
      @transaction_record = current_user.transaction_records.create(stock_symbol: stock.symbol, company_name: stock.name, shares: transaction_params[:shares], price: stock.latest_price, transaction_type: transaction_type)
      flash[:notice] = flash_message
      redirect_to my_portfolio_path
    rescue FrozenError
      flash[:notice] = "Selling successful!"
      redirect_to my_portfolio_path
    end
  end

  private

  def transaction_params
    params.require(:transaction).permit(:symbol, :shares)
  end

  def disallow_unapproved_trader
		if !current_user.approved?
			flash[:alert] = "Only approved traders can trade stocks."
			redirect_to my_portfolio_path
		end
	end

  def remove_stock_from_transactions(transaction, stock, shares)
    transaction.destroy
    current_user.transaction_records.create(stock_symbol: stock.symbol, company_name: stock.name, shares: shares, price: stock.latest_price, transaction_type: "sell")
  end

  def restrict_stock_selling
    if params[:transaction_type_sell] == "True" && transaction_params[:shares].to_d > Transaction.find(params[:id]).shares
      flash[:alert] = "You cannot sell more stocks than you have."
      redirect_to my_portfolio_path
    end
  end

  def require_stock_shares
    if !transaction_params[:shares].present?
      flash[:alert] = "Please input number of shares you want to buy/sell."
      redirect_to my_portfolio_path
    end
  end

end
