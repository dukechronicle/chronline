require 'resque/server'
require_dependency 'site/users_controller' # contains site devise controllers

Chronline::Application.routes.draw do
  get 'robots' => 'robots#show', format: true, constraints: {format: :txt}

  constraints subdomain: 'beta' do
    devise_for :users, controllers: {
      sessions: 'site/sessions',
      registrations: 'site/registrations',
      passwords: 'site/passwords',
      omniauth_callbacks: 'site/omniauth_callbacks',
    }

    namespace :beta, path: '/'  do
      get 'sitemap' => 'base#sitemap_proxy', format: true, constraints: {format: 'xml.gz'}

      resources :galleries, only: [:index, :show], id: Gallery::SLUG_PATTERN

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
        get 'categories/:category' => 'blog_posts#categories', as: :category
      end

      resources :staff, only: :show do
        member do
          get 'articles'
          get 'blog_posts'
          get 'images'
        end
      end

      resources :tournaments, only: :show, id: Tournament::SLUG_PATTERN do
        member do
          get 'challenge'
          get 'leaderboard'
        end
      end
      resources :tournaments, only: :none do
        resources :tournament_brackets, except: :edit, path: 'brackets',
          tournament_id: Tournament::SLUG_PATTERN
      end

      resources :polls, only: :show  do
        member do
          post 'vote'
        end
      end

      match '/404', :to => 'base#not_found'

      match 'join' => redirect('/pages/join')

      # Legacy routes
      %w[news sports opinion recess towerview].each do |section|
        match section => redirect("/section/#{section}")
      end

      match 'rss' => redirect("http://rss.#{ENV['DOMAIN']}/articles")

      # The controller methods redirect to the most current route
      get 'article/:id' => 'articles#show', as: :article_deprecated
      get 'article/:id/print' => 'articles#print', as: :print_article_deprecated
    end
  end


  constraints subdomain: 'www' do
    devise_for :users, controllers: {
      sessions: 'site/sessions',
      registrations: 'site/registrations',
      passwords: 'site/passwords',
      omniauth_callbacks: 'site/omniauth_callbacks',
    }

    namespace :site, path: '/' do
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

      resources :staff, only: :show do
        member do
          get 'articles'
          get 'blog_posts'
          get 'images'
        end
      end

      resources :tournaments, only: :show, id: Tournament::SLUG_PATTERN do
        member do
          get 'challenge'
          get 'leaderboard'
        end
      end
      resources :tournaments, only: :none do
        resources :tournament_brackets, except: :edit, path: 'brackets',
          tournament_id: Tournament::SLUG_PATTERN
      end

      resources :blogs, only: :index, controller: 'blog_posts' do
        resources :posts, only: [:index, :show], controller: 'blog_posts',
          id: Post::SLUG_PATTERN
        get 'tags/:tag' => 'blog_posts#tags', as: :tagged
        get 'categories/:category' => 'blog_posts#categories', as: :category
      end

      match 'join' => redirect('/pages/join', subdomain: :beta)

      resources :polls, only: :show  do
        member do
          post 'vote'
        end
      end

      # Legacy routes
      %w[news sports opinion recess towerview].each do |section|
        match section => redirect("/section/#{section}")
      end

      match 'rss' => redirect("http://rss.#{ENV['DOMAIN']}/articles")

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

      match 'join' => redirect("http://www.#{ENV['DOMAIN']}/pages/join?force_full_site=true")

      # Legacy routes
      # The controller method redirects to the most current route
      get 'article/:id' => 'articles#show', as: :article_deprecated
    end
  end

  constraints subdomain: 'admin' do
    namespace :admin, path: '/'  do
      root to: 'main#home'

      get 'newsletter' => 'newsletter#show'
      post 'newsletter' => 'newsletter#send_newsletter'
      get 'section/*section' => 'articles#index', as: :article_section

      get 'widgets' => 'widgets#index'
      get 'widgets/match_url' => 'widgets#match_url'

      resources :images, except: :show do
        put 'crop', on: :member
        get 'upload', on: :collection
      end

      resources :galleries, except: :show, id: Gallery::SLUG_PATTERN do
        post 'scrape', on: :collection
      end

      resources :articles, except: :show, id: Post::SLUG_PATTERN do
        post :publish, on: :member
      end

      resources :pages, except: :show
      resources :staff, except: :show

      resources :topics do
        member do
          post :archive
        end
        resources :responses, only: [:create, :destroy], controller: 'topic_responses' do
          member do
            post :approve
            post :report
          end
        end
      end

      resources :blogs, only: :index, controller: 'blog_posts' do
        resources :posts, except: :show, controller: 'blog_posts',
          id: Post::SLUG_PATTERN
      end

      resources :blog_series, except: :show

      resources :polls, except: :show

      resource :configuration, only: [:show, :update], controller: 'sitevars'

      resources :users, only: [:index, :show] do
        post :change_role, on: :member
      end

      resources :tournaments, id: Tournament::SLUG_PATTERN
      resources :tournaments, only: :none do
        resources :tournament_teams, only: [:new, :create, :edit, :update],
          path: 'teams', tournament_id: Tournament::SLUG_PATTERN
      end

      authenticate :user do
        mount Resque::Server.new, at: '/resque'
      end
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
      resources :blogs, only: :none do
        resources :posts, only: :index, controller: 'blog_posts'
      end
      resources :posts, except: [:new, :edit], id: Post::SLUG_PATTERN do
        post :unpublish, on: :member
      end
      resources :topics, only: :none do
        resources :responses, only: [:index, :create], controller: 'topic_responses' do
          member do
            post :upvote
            post :downvote
            post :report
          end
        end
      end

    end
  end

  constraints subdomain: 'rss' do
    namespace :rss, path: '/' do
      get 'section/*section' => 'articles#index', as: :article_section
      resources :articles, only: :index
      resources :blogs, only: :none do
        resources :posts, only: :index, controller: 'blog_posts'
      end
    end
  end

end
