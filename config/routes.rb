Rails.application.routes.draw do
  get 'abouts/index'
  devise_for :users
  resources :users, only: [:show, :edit, :update] do
    member do
          get :followed, :followers
    end
  end
  resources :relationships, only: [:create, :destroy]

  get '/about', to: "abouts#index"

  root 'restaurants#top'

  resources :restaurants do
    resource :favorites, only: [:create, :destroy]
    resources :post_comments, only: [:create, :destroy]
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

end
