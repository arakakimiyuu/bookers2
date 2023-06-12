Rails.application.routes.draw do

  devise_for :users
  root to: "homes#top"
  get "home/about" => "homes#about",as: "about"

  devise_scope :user do
    post "users/guest_sign_in", to: "users/sessions#guest_sign_in"
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :books, only:[:create, :index, :show, :edit, :update,:destroy] do
    resource :favorites, only:[:create, :destroy]
    resources :book_comments, only:[:create, :destroy]
  end
  resources :users, only:[:new, :index, :create, :show, :edit, :update] do
    resource :relationships, only: [:create, :destroy]
    get 'followings' => 'relationships#followings', as: 'followings'
    get 'followers' => 'relationships#followers', as: 'followers'
    get "search_form"=> "users#search_form"
  end

  get "search" => "searches#search"

  resources :rooms, only:[:create, :show]
  resources :messages, only:[:create]
  resources :groups, only:[:new, :index, :show, :create, :edit, :update] do
    resource :group_users, only:[:create, :destroy]
  end
end