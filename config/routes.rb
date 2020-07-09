Rails.application.routes.draw do
  devise_for :users
  resources :users, only: [:show, :edit, :update] do
    resource :relationships, only: [:create, :destory]
    get 'follows' => 'relationships#follower', as: 'follows'
    get 'followers' => 'relationships#followed', as: 'followers'
  end

  root 'restaurants#index'
  resources :restaurants, only: [:show, :create, :edit, :update, :destory] do
    resource :favorites
    resources :post_comments
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

end
