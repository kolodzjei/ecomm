# frozen_string_literal: true

class SessionsController < ApplicationController
  before_action :redirect_if_authenticated, only: [:new, :create]
  before_action :authenticate_user!, only: [:destroy]
  def new; end

  def create
    @user = User.find_by(email: params[:user][:email].downcase)
    @user = nil if @user&.disabled?

    if @user
      if @user.unconfirmed?
        redirect_to(new_confirmation_path, alert: "You must confirm your email address before continuing")
      elsif @user.authenticate(params[:user][:password])
        after_login_path = session[:user_return_to] || root_path
        login(@user)
        remember(@user) if params[:user][:remember_me] == "1"
        redirect_to(after_login_path, notice: "You are now logged in.")
      else
        flash.now[:alert] = "Invalid email or password."
        render(:new, status: :unprocessable_entity)
      end
    else
      flash.now[:alert] = "Invalid email or password."
      render(:new, status: :unprocessable_entity)
    end
  end

  def destroy
    return if current_user.nil?

    forget(current_user)
    logout
    redirect_to(root_path, notice: "You are now logged out.")
  end
end
