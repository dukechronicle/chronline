require 'resque/server'
require_dependency 'admin/users_controller' # contains admin devise controllers

Chronline::Application.routes.draw do
  get 'robots' => 'robots#show', format: true, constraints: {format: :txt}

  constraints subdomain: 'www' do
    namespace :site, path: '/'  do
      get 'sitemap' => 'base#sitemap_proxy', format: true, constraints: {format: 'xml.gz'}

      resource :search, only: :show

      resource :newsletter, only: :show do
        post 'subscribe'
        post 'unsubscribe'
      end

      root to: 'articles#index'
      get 'section/*section' => 'articles#index', as: :article_section
      get 'pages/*path' => 'base#custom_page'

      resources :articles, only: :show, id: Post::SLUG_PATTERN do
        get :print, on: :member
      end

      resources :blogs, only: :index, controller: 'blog_posts' do
        resources :posts, only: [:index, :show], controller: 'blog_posts',
          id: Post::SLUG_PATTERN
        get 'tags/:tag' => 'blog_posts#tags', as: :tagged
      end

      resources :staff, only: :show do
        member do
          get 'articles'
          get 'images'
        end
      end

      match '/404', :to => 'base#not_found'

      match 'join' => redirect('/pages/join')

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
      resources :articles, only: :show, id: Post::SLUG_PATTERN

      resource :search, only: :show

      resources :blogs, only: :index, controller: 'blog_posts' do
        resources :posts, only: [:index, :show], controller: 'blog_posts',
          id: Post::SLUG_PATTERN
      end

      match '/404', :to => 'base#not_found'

      match 'join' => redirect("http://www.#{Settings.domain}/pages/join?force_full_site=true")

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

      resources :images, except: :show do
        put 'crop', on: :member
        get 'upload', on: :collection
      end

      resources :articles, except: :show, id: Post::SLUG_PATTERN do
        post :publish, on: :member
      end

      resources :pages, except: :show
      resources :staff, except: :show

      resources :blogs, only: :index, controller: 'blog_posts' do
        resources :posts, except: :show, controller: 'blog_posts',
          id: Post::SLUG_PATTERN
      end

      mount Resque::Server.new, at: '/resque'
    end
  end

  constraints subdomain: 'api', format: :json do
    namespace :api, path: '/', defaults: {format: :json} do
      get 'sections' => 'taxonomy#index'

      get 'qduke' => 'qduke#frontpage'
      get 'section/*section' => 'articles#index', as: :article_section

      resource :search, only: :show

      resources :images, except: [:new, :edit]
      resources :staff, except: [:new, :edit]
      resources :articles, except: [:new, :edit], id: Post::SLUG_PATTERN do
        post :unpublish, on: :member
      end
      resources :blogs, only: [], controller: 'blog_posts' do
        resources :posts, only: :index, controller: 'blog_posts'
      end
      resources :posts, except: [:new, :edit], id: Post::SLUG_PATTERN do
        post :unpublish, on: :member
      end
    end
  end

  constraints subdomain: 'rss' do
    namespace :rss, path: '/' do
      get 'section/*section' => 'articles#index', as: :article_section
      resources :articles, only: :index
    end
  end

end
