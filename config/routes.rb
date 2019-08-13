Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      namespace :merchants do
        get '/find', to: 'search#show'
        get '/find_all', to: 'search#index'
        get '/random', to: 'random#show'
      end
      get '/items/most_items', to: 'item_sales#index'
      resources :merchants, only: [:show, :index]
      resources :customers, only: [:show, :index]
      resources :items, only: [:show, :index]
      resources :invoices, only: [:show, :index]
    end
  end
end
