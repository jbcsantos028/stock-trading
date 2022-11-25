Rails.application.routes.draw do
  resources :transaction_records, only: [:index]
  resources :transactions, only: [:create, :update]
  resources :users
  devise_for :users
  root to: 'transactions#index'
  get 'get_stock_quote', to: 'stocks#get_quote'
  get 'edit_transaction', to: 'transactions#edit'
  get 'my_portfolio', to: 'transactions#index'
  
  get 'adminpanel', to: 'users#adminpanel'
end
