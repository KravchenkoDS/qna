Rails.application.routes.draw do

  devise_for :users
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
  end

  resources :files, only: :destroy
  resources :links, only: :destroy
  resources :awards, only: :index

  mount ActionCable.server => '/cable'
end
