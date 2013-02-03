require_dependency 'admin/users_controller' # contains admin devise controllers

Chronline::Application.routes.draw do
  get 'robots' => 'robots#show', format: true, constraints: {format: :txt}

  constraints subdomain: 'www' do
    namespace :site, path: '/'  do
      match 'rss' => redirect('http://feeds.feedburner.com/thechronicle/all')
      get 'search' => 'articles#search'
      resource :newsletter, only: :show do
        post 'subscribe'
        post 'unsubscribe'
      end

      root to: 'base#custom_page'
      get 'pages/*path' => 'base#custom_page'
      get 'section/*section' => 'articles#index', as: :article_section

      get 'article/:id' => 'articles#show', as: :article
      get 'article/:id/print' => 'articles#print', as: :print_article

      resources :staff, only: :show

      match '/404', :to => 'base#not_found'
    end
  end

  constraints subdomain: 'm' do
    namespace :mobile, path: '/'  do
      root to: 'articles#index'
      get 'section/*section' => 'articles#index', as: :article_section
      get 'search' => 'articles#search', as: :article_search
      get 'article/:id' => 'articles#show', as: :article

      match '/404', :to => 'base#not_found'
    end
  end

  constraints subdomain: 'admin' do
    devise_for :users, controllers: {
      sessions: 'admin/sessions',
      invitations: 'admin/invitations',
      passwords: 'admin/passwords',
    }

    namespace :admin, path: '/'  do
      root to: 'main#home'

      get 'newsletter' => 'newsletter#show'
      post 'newsletter' => 'newsletter#send_newsletter'
      get 'section/*section' => 'articles#index', as: :article_section
      get 'search' => 'articles#search', as: :article_search

      resources :images, except: :show do
        put 'crop', on: :member
        get 'upload', on: :collection
      end
      resources :articles, except: :show
      resources :pages, except: :show
      resources :staff, except: :show
    end
  end

  constraints subdomain: 'api' do
    namespace :api, path: '/' do
      get 'section/*section' => 'articles#index', as: :article_section
      get 'search' => 'articles#search'

      resources :images, only: :index
      resources :staff, only: :index
      resources :articles, only: :index
    end
  end

  constraints subdomain: 'rss' do
    namespace :rss, path: '/' do
      get 'section/*section' => 'articles#index', as: :article_section
      resources :articles, only: :index
    end
  end

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
