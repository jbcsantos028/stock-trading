class StocksController < ApplicationController
  

  def get_quote
    if params[:stock].present?
      @stock = Stock.new_quote(params[:stock])
      owned_stock = Stock.check_db(params[:stock])
      if owned_stock
        @owned_user_stock = current_user.user_stocks.where(stock_id: owned_stock.id).first
      end
      if @stock
        respond_to do |format|
          format.js { render partial: 'user_stocks/quote' }
        end
      else
        respond_to do |format|
          flash.now[:alert] = "Please enter a valid stock symbol to search."
          format.js { render partial: 'user_stocks/quote' }
        end
      end
    else
      respond_to do |format|
        flash.now[:alert] = "Please enter a stock symbol to search."
        format.js { render partial: 'user_stocks/quote' }
      end
    end
  end

  
end