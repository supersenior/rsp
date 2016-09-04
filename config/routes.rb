Rails.application.routes.draw do

  get "log_out" => "sessions#destroy", :as => "log_out"
  get "log_in" => "sessions#new", :as => "log_in"
  # get "sign_up" => "users#new", :as => "sign_up"

  # resources :users, only: [:new, :create]
  resources :sessions, only: [:new, :create, :destroy]
  resources :employers, only: [:index]
  resources :product_types, only: [:index]
  resources :projects, only: [:index, :show, :new, :create, :update] do
    member do
      get :export
      patch :mark_as_sold
    end

    resources :documents do
      collection do
        post :upload_source
      end

      member do
        post :unarchive
      end
    end
  end

  # TODO: nest underneath projects!
  resources :dynamic_values, only: [:update]

  namespace :admin do
    resources :stats, only: [:index]

    shallow do
      resources :projects, only: [:show] do
        resources :documents, only: [:show, :update, :create] do
          member do
            get :data_entry_finished
            get :review_finished
          end

          resources :sources, only: [:create, :show, :update]
          resources :products, only: [:update, :create, :destroy] do
            resources :product_classes, only: [:update, :create, :destroy]
          end
        end
      end
    end

    resources :dynamic_attributes
    resources :product_types
    resources :categories
    resources :carriers do
      resources :orderings
    end
    resources :users, only: [] do
      collection do
        get :stop_impersonating, as: :stop_impersonation
      end

      member do
        get :impersonate, :impersonate
      end
    end
    get "/" => "pages#dashboard"
  end

  root 'pages#index'
end
