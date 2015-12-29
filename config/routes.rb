Rails.application.routes.draw do

  devise_for :users,
    :controllers => { :registrations => "registrations", :sessions => "sessions",omniauth_callbacks: 'omniauth_callbacks' }
  resources :users, :only => [:edit, :update, :index] do
    resources :conversations, :only => :index
    get 'notifications'
    post 'upload_file'
    collection do
      post 'autocomplete'
    end
    resources :subscriptions, :only => [:create,:destroy,:index]
  end

  resources :comments, :only => [:create, :destroy]

  resources :game_improvements, :only => [:create, :destroy, :show]
  resources :games do
    resources :game_boards

  end

  resources :votes, :only => [] do
    collection do
      post 'up'
      post 'down'
    end
  end

  resources :board_suggestions, :only => [:create,:destroy, :show]
  resources :invitations, :only => [] do
    collection do
      post 'check'
    end
  end

  resources :game_boards do
    collection do
      get 'popular'
      get 'archives'
    end
  end

  resources :workspaces

  resources :posts do
    post 'create_or_destroy_reaction'
    post 'flag_vote'
    collection do
      get 'popular'
      get 'familiar'
      get 'subscriptions'
      get 'user_games'
      get 'flagged'
      get 'autocomplete_tag_search'
    end
    member do
      post 'create_or_destroy_reaction'
    end
  end

  resources :conversations, :only => [:create,:show,:index, :destroy] do
    resources :messages, :only => [:create]
  end

  root 'pages#home'
  get '/pages/:page_name' => 'pages#index', :as => :pages
  get '/posts/:category/:tag' => 'posts#index', :as => :filtered_posts
  get '/sitemap.xml' => 'pages#sitemap'
  match '/users/:id/finish_signup' => 'users#finish_signup', via: [:get, :patch], :as => :finish_signup
  match '/users/search' => 'users#search', via: [:get]
  # This needs to stay at the bottom such that a user can't override a preset URL
  match '/:display_name', :controller => :users, :action => :show, :as => :profile, via: [:get]
  get "/stats/:type", :as => 'stats', :controller => :stats, :action => :index


  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
