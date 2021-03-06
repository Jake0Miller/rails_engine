Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      namespace :customers do
        get '/find', to: 'search#show'
        get '/find_all', to: 'search#index'
        get '/random', to: 'random#show'
        get '/:id/favorite_merchant', to: 'merchant#show'
        get '/:id/invoices', to: 'invoices#index'
        get '/:id/transactions', to: 'transactions#index'
      end

      namespace :invoices do
        get '/find', to: 'search#show'
        get '/find_all', to: 'search#index'
        get '/random', to: 'random#show'
        get '/:id/customer', to: 'customer#show'
        get '/:id/invoice_items', to: 'invoice_items#index'
        get '/:id/items', to: 'items#index'
        get '/:id/merchant', to: 'merchant#show'
        get '/:id/transactions', to: 'transactions#index'
      end

      namespace :invoice_items do
        get '/find', to: 'search#show'
        get '/find_all', to: 'search#index'
        get '/random', to: 'random#show'
        get '/:id/invoice', to: 'invoice#show'
        get '/:id/item', to: 'item#show'
      end

      namespace :items do
        get '/find', to: 'search#show'
        get '/find_all', to: 'search#index'
        get '/random', to: 'random#show'
        get '/most_items', to: 'item_sales#index'
        get '/most_revenue', to: 'item_revenue#index'
        get '/:id/best_day', to: 'item_sales#show'
        get '/:id/invoice_items', to: 'invoice_items#index'
        get '/:id/merchant', to: 'merchant#show'
      end

      namespace :merchants do
        get '/find', to: 'search#show'
        get '/find_all', to: 'search#index'
        get '/random', to: 'random#show'
        get '/most_items/', to: 'most_items#index'
        get '/most_revenue/', to: 'most_revenue#index'
        get '/revenue', to: 'revenue#show'
        get '/:id/customers_with_pending_invoices/', to: 'customer_orders#index'
        get '/:id/favorite_customer', to: 'favorite_customer#show'
        get '/:id/invoices', to: 'invoices#index'
        get '/:id/revenue', to: 'total_revenue#show'
        get '/:id/items', to: 'items#index'
      end

      namespace :transactions do
        get '/find', to: 'search#show'
        get '/find_all', to: 'search#index'
        get '/random', to: 'random#show'
        get '/:id/invoice', to: 'invoice#show'
      end

      resources :customers, only: [:show, :index]
      resources :invoices, only: [:show, :index]
      resources :invoice_items, only: [:show, :index]
      resources :items, only: [:show, :index]
      resources :merchants, only: [:show, :index]
      resources :transactions, only: [:show, :index]
    end
  end
end
