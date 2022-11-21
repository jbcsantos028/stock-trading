class UsersController < ApplicationController
  def my_portfolio
    @owned_stocks = current_user.user_stocks
    # @owned_stocks = current_user.user_stocks
  end
end
