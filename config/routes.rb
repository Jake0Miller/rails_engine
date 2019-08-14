Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      namespace :items do
        get '/find', to: 'search#show'
        get '/find_all', to: 'search#index'
        get '/random', to: 'random#show'
        get '/most_items', to: 'item_sales#index'
        get '/:id/best_day', to: 'item_sales#show'
      end

      namespace :merchants do
        get '/find', to: 'search#show'
        get '/find_all', to: 'search#index'
        get '/random', to: 'random#show'
      end

      resources :merchants, only: [:show, :index]
      resources :customers, only: [:show, :index]
      resources :items, only: [:show, :index]
      resources :invoices, only: [:show, :index]
    end
  end
end
