# frozen_string_literal: true

Rails.application.routes.draw do
  root 'static_pages#home'
  post 'signup', to: 'users#create'
  get 'signup', to: 'users#new'
  resources :confirmations, only: %i[create edit new], param: :confirmation_token
  post 'login', to: 'sessions#create'
  get 'login', to: 'sessions#new'
  delete 'logout', to: 'sessions#destroy'
  resources :passwords, only: %i[create edit new update], param: :password_reset_token
  put 'profile', to: 'users#update'
  get 'profile', to: 'users#edit'
  delete 'profile', to: 'users#destroy'
end
