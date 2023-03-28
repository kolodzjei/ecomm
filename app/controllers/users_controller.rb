# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :authenticate_user!, only: %i[edit update destroy index disable]
  before_action :authenticate_admin!, only: %i[index disable]

  def index
    @pagy, @users = pagy(User.all, items: 20)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(create_user_params)

    if @user.save
      @user.send_confirmation_email!
      redirect_to root_path, notice: 'Please check your email for confirmation instructions.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @user = current_user
    @pagy, @orders = pagy(current_user.orders, items: 5)
  end

  def update
    @user = current_user
    if @user.authenticate(params[:user][:current_password])
      if @user.update(update_user_params)
        if params[:user][:unconfirmed_email].present?
          @user.send_confirmation_email!
          redirect_to root_path, notice: 'Please check your email for confirmation instructions.'
        else
          redirect_to root_path, notice: 'Your account has been updated.'
        end
      else
        render :edit, status: :unprocessable_entity
      end
    else
      flash.now[:error] = 'Incorrect password'
      render :edit, status: :unprocessable_entity
    end
  end

  def disable
    @user = User.find_by(id: params[:id])
    @user.update_attribute(:disabled, true)
    flash[:notice] = 'User disabled'
    redirect_to users_path
  end

  def enable
    @user = User.find_by(id: params[:id])
    @user.update_attribute(:disabled, false)
    flash[:notice] = 'User unlocked'
    redirect_to users_path
  end

  private

  def create_user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def update_user_params
    params.require(:user).permit(:name, :current_password, :password, :password_confirmation, :unconfirmed_email)
  end
end
