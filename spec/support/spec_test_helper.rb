# frozen_string_literal: true

module SpecTestHelper
  def current_user
    Current.user ||= if session[:current_user_id].present?
                       User.find_by(id: session[:current_user_id])
                     elsif cookies.encrypted[:remember_token].present?
                       User.find_by(remember_token: cookies.permanent.encrypted[:remember_token])
                     end
  end

  def login_as(user)
    post login_path, params: { user: { email: user.email, password: user.password } }
  end

  def log_out
    delete logout_path
  end
end
