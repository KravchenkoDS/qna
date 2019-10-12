require 'sidekiq/web'

Rails.application.routes.draw do
  authenticate :user, lambda {|u| u.admin?} do
    mount Sidekiq::Web => '/sidekiq'
  end

  use_doorkeeper
  devise_for :users, controllers: {
      omniauth_callbacks: 'oauth_callbacks',
      confirmations: 'oauth_confirmations'
  }

  root to: 'questions#index'

  concern :votable do
    member do
      post :vote_up
      post :vote_down
      delete :vote_destroy
    end
  end

  concern :commentable do
    resources :comments, shallow: true, only: :create
  end

  resources :questions, concerns: %i[votable commentable] do
    resources :answers, shallow: true, concerns: %i[votable commentable] do
      patch :best, on: :member
    end
    resources :subscriptions, only: %i[create destroy]
  end

  resources :files, only: :destroy
  resources :links, only: :destroy
  resources :awards, only: :index
  resources :users, only: :show

  namespace :api do
    namespace :v1 do
      resources :profiles, only: :index do
        get :me, on: :collection
      end
      resources :questions, except: %i[new edit], shallow: true do
        resources :answers, except: %i[new edit]
      end
    end
  end

  mount ActionCable.server => '/cable'
end
