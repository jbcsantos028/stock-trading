class TransactionsController < ApplicationController
require 'bigdecimal/util'

  def index
    @owned_stocks = current_user.transactions
    render :my_portfolio
  end

  def create
    stock = Stock.check_db(params[:symbol])
    if stock.blank?
      stock = Stock.new_quote(params[:symbol])
      stock.save
    end
    @transaction = current_user.transactions.create(stock: stock, shares: params[:shares])
    flash[:notice] = "Purchase successful!"
    redirect_to my_portfolio_path
  end

  def edit
    if params[:transaction_type_sell].present?
      @transaction_type_sell = params[:transaction_type_sell]
    end

    @stock = Stock.find(params[:id])
    @owned_stock = current_user.transactions.where(stock_id: @stock.id).first

    respond_to do |format|
      format.js { render partial: 'transactions/quote' }
    end
    
  end

  def update
    @transaction = Transaction.find(params[:id])

    if params[:transaction_type_sell] == "True"
      updated_shares = @transaction.shares - params[:shares].to_d
      flash_message = "Selling successful!"
    else
      updated_shares = @transaction.shares + params[:shares].to_d
      flash_message = "Purchase successful!"
    end
    
    @transaction.update(shares: updated_shares)
    flash[:notice] = flash_message
    redirect_to my_portfolio_path
  end

end
