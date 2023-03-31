# frozen_string_literal: true

class PasswordsController < ApplicationController
  before_action :redirect_if_authenticated

  def new; end

  def edit
    @user = User.find_signed(params[:password_reset_token], purpose: :reset_password)
    if @user.present? && @user.unconfirmed?
      redirect_to(
        new_confirmation_path,
        alert: "Please confirm your email first.",
      )
    elsif @user.nil?
      redirect_to(new_password_path, alert: "Invalid token.")
    end
  end

  def create
    @user = User.find_by(email: params[:user][:email].downcase)
    if @user.present?
      if @user.confirmed?
        @user.send_password_reset_email!
        redirect_to(root_path, notice: "Check your email for password reset instructions.")
      else
        redirect_to(
          new_confirmation_path,
          alert: "Please confirm your email first.",
        )
      end
    else
      redirect_to(root_path, alert: "We could not find a user with that email.")
    end
  end

  def update
    @user = User.find_signed(params[:password_reset_token], purpose: :password_reset)
    if @user
      if @user.unconfirmed?
        redirect_to(new_confirmation_path, alert: "Please confirm your email first.")
      elsif @user.update(password_params)
        redirect_to(login_path, notice: "Your password has been reset.")
      else
        flash.now[:alert] = @user.errors.full_messages.to_sentence
        render(:edit, status: :unprocessable_entity)
      end
    else
      flash.now[:alert] = "Invalid token."
      render(:new, status: :unprocessable_entity)
    end
  end

  private

  def password_params
    params.require(:user).permit(:password, :password_confirmation)
  end
end
