Rails.application.routes.draw do
  resources :transactions, only: [:create, :update]
  devise_for :users
  root to: 'transactions#index'
  get 'get_stock_quote', to: 'stocks#get_quote'
  get 'edit_transaction', to: 'transactions#edit'
  get 'my_portfolio', to: 'transactions#index'
end
