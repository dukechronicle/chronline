require_dependency 'admin/users_controller' # contains admin devise controllers

Chronline::Application.routes.draw do
  get 'robots' => 'robots#show', format: true, constraints: {format: :txt}

  constraints subdomain: 'www' do
    namespace :site, path: '/'  do
      get 'search' => 'articles#search'
      resource :newsletter, only: :show do
        post 'subscribe'
        post 'unsubscribe'
      end

      root to: 'articles#index'
      get 'section/*section' => 'articles#index', as: :article_section
      get 'pages/*path' => 'base#custom_page'

      resources :articles, only: :show, id: %r[(\d{4}/\d{2}/\d{2}/)?[^/]+] do
        get :print, on: :member
      end

      resources :staff, only: :show do
        member do
          get 'articles'
          get 'images'
        end
      end

      match '/404', :to => 'base#not_found'

      # Legacy routes
      %w[news sports opinion recess towerview].each do |section|
        match section => redirect("/section/#{section}")
      end

      match 'rss' => redirect("http://rss.#{Settings.domain}/articles")

      # The controller methods redirect to the most current route
      get 'article/:id' => 'articles#show', as: :article_deprecated
      get 'article/:id/print' => 'articles#print', as: :print_article_deprecated
    end
  end

  constraints subdomain: 'm' do
    namespace :mobile, path: '/'  do
      root to: 'articles#index'
      get 'section/*section' => 'articles#index', as: :article_section
      get 'search' => 'articles#search', as: :article_search
      resources :articles, only: :show, id: %r[(\d{4}/\d{2}/\d{2}/)?[^/]+]

      match '/404', :to => 'base#not_found'

      # Legacy routes
      # The controller method redirects to the most current route
      get 'article/:id' => 'articles#show', as: :article_deprecated
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
      post 'articles/publish' => 'articles#publish'

      resources :images, except: :show do
        put 'crop', on: :member
        get 'upload', on: :collection
      end

      resources :articles, id: %r[(\d{4}/\d{2}/\d{2}/)?[^/]+]
      resources :pages, except: :show
      resources :staff, except: :show
    end
  end

  constraints subdomain: 'api' do
    namespace :api, path: '/' do
      get 'qduke' => 'qduke#frontpage'
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

end
