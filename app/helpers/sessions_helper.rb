# frozen_string_literal: true

module SessionsHelper
  def current_user
    Current.user ||= if session[:current_user_id].present?
      User.find_by(id: session[:current_user_id])
    elsif cookies.encrypted[:remember_token].present?
      User.find_by(remember_token: cookies.permanent.encrypted[:remember_token])
    end

    if Current.user.present? && Current.user.disabled?
      logout
      Current.user = nil
      redirect_to(root_path, alert: "Your account has been disabled.")
    end

    Current.user
  end

  def logged_in?
    !!current_user
  end

  def admin?
    logged_in? && current_user.admin?
  end
end
