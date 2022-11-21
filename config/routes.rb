Rails.application.routes.draw do
  resources :user_stocks, only: [:create, :update]
  devise_for :users
  # root 'welcome#index'
  root to: 'users#my_portfolio'
  get 'my_portfolio', to: 'users#my_portfolio'
  get 'get_stock_quote', to: 'stocks#get_quote'
  get 'edit_user_stock', to: 'user_stocks#edit'
end
