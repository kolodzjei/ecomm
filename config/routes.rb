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
  resources :products, only: %i[index show new create edit update destroy]
  resources :carts, only: %i[show]
  resources :items, only: %i[create destroy]
  post 'items/:id/add', to: 'items#add', as: 'add_item'
  delete 'items/:id/remove', to: 'items#remove', as: 'remove_item'
  resources :orders, only: %i[index show new create]
  delete 'orders/:id/cancel', to: 'orders#cancel', as: 'cancel_order'
  get 'orders/:id/pay', to: 'orders#pay', as: 'pay_order'
  post 'orders/:id/ship', to: 'orders#ship', as: 'ship_order'
  post 'orders/:id/receive', to: 'orders#receive', as: 'receive_order'
  post 'orders/:id/pay', to: 'orders#paid', as: 'paid_order'
end
