class UserStocksController < ApplicationController
require 'bigdecimal/util'

  def index
    @owned_stocks = current_user.user_stocks
    render :my_portfolio
  end

  def create
    stock = Stock.check_db(params[:symbol])
    if stock.blank?
      stock = Stock.new_quote(params[:symbol])
      stock.save
    end
    @user_stock = current_user.user_stocks.create(stock: stock, shares: params[:shares])
    flash[:notice] = "Purchase successful!"
    redirect_to my_portfolio_path
  end

  def edit
    if params[:transaction_type].present?
      @transaction_type = params[:transaction_type]
    end
    @stock = Stock.find(params[:id])
    @owned_user_stock = current_user.user_stocks.where(stock_id: @stock.id).first
    respond_to do |format|
      format.js { render partial: 'user_stocks/quote' }
    end
    
  end

  def update
    @user_stock = UserStock.find(params[:id])
    if params[:transaction_type].present?
      updated_shares = @user_stock.shares - params[:shares].to_d
      flash_message = "Sell successful!"
    else
      updated_shares = @user_stock.shares + params[:shares].to_d
      flash_message = "Purchase successful!"
    end
    @user_stock.update(shares: updated_shares)
    flash[:notice] = flash_message
    redirect_to my_portfolio_path
  end

end
