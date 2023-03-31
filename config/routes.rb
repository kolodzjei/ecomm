# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :admin do
    get "dashboard", to: "dashboard#index", as: "dashboard"
    get "summary", to: "orders_summary#index", as: "summary"
    post "summary/download_csv", to: "orders_summary#download_csv", as: "download_csv"
    get "summary/check_job_status", to: "orders_summary#check_job_status", as: "check_job_status"
    get "summary/download_orders_csv", to: "orders_summary#download_orders_csv", as: "download_orders_csv"
  end
  resources :users, only: [:index]
  root "static_pages#home"
  post "signup", to: "users#create"
  get "signup", to: "users#new"
  resources :confirmations, only: [:create, :edit, :new], param: :confirmation_token
  post "login", to: "sessions#create"
  get "login", to: "sessions#new"
  delete "logout", to: "sessions#destroy"
  resources :passwords, only: [:create, :edit, :new, :update], param: :password_reset_token
  put "profile", to: "users#update"
  get "profile", to: "users#edit"
  delete "profile", to: "users#destroy"
  resources :products, only: [:index, :show, :new, :create, :edit, :update, :destroy]
  resources :carts, only: [:index], path: "cart"
  resources :items, only: [:create, :destroy]
  post "items/:id/add", to: "items#add", as: "add_item"
  delete "items/:id/remove", to: "items#remove", as: "remove_item"
  resources :orders, only: [:index, :show, :new, :create]
  delete "orders/:id/cancel", to: "orders#cancel", as: "cancel_order"
  get "orders/:id/pay", to: "orders#pay", as: "pay_order"
  post "orders/:id/ship", to: "orders#ship", as: "ship_order"
  post "orders/:id/receive", to: "orders#receive", as: "receive_order"
  post "orders/:id/pay", to: "orders#paid", as: "paid_order"
  resources :categories, only: [:index, :create, :destroy, :update, :edit, :new]
  resources :wishlists, only: [:index, :create, :destroy], path: "wishlist"
  post "wishlist/add/:product_id", to: "wishlists#create", as: "wishlist_add"
  delete "wishlist/remove/:product_id", to: "wishlists#destroy", as: "wishlist_remove"
  post "cart/add/:product_id", to: "items#create", as: "cart_add"
  delete "users/:id/disable", to: "users#disable", as: "disable_user"
  post "users/:id/enable", to: "users#enable", as: "enable_user"
  resources :reviews, only: [:create, :destroy]
end
