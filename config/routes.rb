Rails.application.routes.draw do

  resources :transaction_records, only: [:index]
  resources :transactions, only: [:create, :update]

  devise_for :users

  scope "/admin" do
    resources :users, except: [:index, :destroy]
  end

  authenticated :user, ->(u) { u.admin? } do
    root to: 'users#adminpanel', as: :admin_root
  end
  
  authenticated :user, ->(u) { u.trader? } do
    root to: 'transactions#index', as: :trader_root
  end

  root to: 'transactions#index'
  
  get 'get_stock_quote', to: 'stocks#get_quote'
  get 'edit_transaction', to: 'transactions#edit'
  get 'my_portfolio', to: 'transactions#index'
  
  get 'adminpanel', to: 'users#adminpanel'
  get 'approve', to: 'users#approve'
  patch 'approve_trader', to: 'users#approve_trader'

  namespace :admin do
    resources :transaction_records, only: [:index]
  end

end
