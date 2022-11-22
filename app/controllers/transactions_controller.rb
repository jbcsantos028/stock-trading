class TransactionsController < ApplicationController
require 'bigdecimal/util'

  def index
    @owned_stocks = current_user.transactions
    render :my_portfolio
  end

  def create
    stock = Stock.check_db(transaction_params[:symbol]) #lines 11 to 14 can be done using find_or_create_by
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
      transaction_type = "sell"
      flash_message = "Selling successful!"
    else
      updated_shares = @transaction.shares + transaction_params[:shares].to_d
      transaction_type = "buy"
      flash_message = "Purchase successful!"
    end
    
    @transaction.update(shares: updated_shares)
    @transaction_record = current_user.transaction_records.create(stock_symbol: stock.symbol, company_name: stock.name, shares: transaction_params[:shares], price: stock.latest_price, transaction_type: transaction_type)
    flash[:notice] = flash_message
    redirect_to my_portfolio_path
  end

  private

  def transaction_params
    params.require(:transaction).permit(:symbol, :shares)
  end 

end
