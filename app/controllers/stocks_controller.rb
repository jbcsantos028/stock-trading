class StocksController < ApplicationController
  

  def get_quote
    if params[:stock].present?
      @stock = Stock.new_quote(params[:stock])
      if @stock
        respond_to do |format|
          format.js { render partial: 'users/quote' }
        end
      else
        flash[:alert] = "Please enter a valid stock symbol to search."
        redirect_to my_portfolio_path
      end
    else
      flash[:alert] = "Please enter a stock symbol to search."
      redirect_to my_portfolio_path
    end
  end

  
end