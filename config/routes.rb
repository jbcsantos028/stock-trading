Rails.application.routes.draw do
  resources :user_stocks, only: [:create, :update]
  devise_for :users
  root to: 'user_stocks#index'
  get 'get_stock_quote', to: 'stocks#get_quote'
  get 'edit_user_stock', to: 'user_stocks#edit'
  get 'my_portfolio', to: 'user_stocks#index'
end
