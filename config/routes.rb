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

  resources :questions, concerns: :votable  do
    resources :answers, shallow: true, concerns: :votable  do
      patch :best, on: :member
    end
  end

  resources :files, only: :destroy
  resources :links, only: :destroy
  resources :awards, only: :index
end
