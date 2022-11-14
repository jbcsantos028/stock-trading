class StocksController < ApplicationController
  

  def get_quote
    if params[:stock].present?
      @stock = Stock.new_quote(params[:stock])
      if @stock
        respond_to do |format|
          format.js { render partial: 'users/quote' }
        end
      else
        respond_to do |format|
          flash.now[:alert] = "Please enter a valid stock symbol to search."
          format.js { render partial: 'users/quote' }
        end
      end
    else
      respond_to do |format|
        flash.now[:alert] = "Please enter a stock symbol to search."
        format.js { render partial: 'users/quote' }
      end
    end
  end

  
end