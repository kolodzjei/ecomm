# frozen_string_literal: true

module SpecTestHelper
  def log_in_user
    user = create(:user)
    post login_path, params: { user: { email: user.email, password: 'password' } }
  end

  def log_in_admin
    user = create(:admin)
    post login_path, params: { user: { email: user.email, password: 'password' } }
  end

  def current_user
    Current.user ||= if session[:current_user_id].present?
                       User.find_by(id: session[:current_user_id])
                     elsif cookies.encrypted[:remember_token].present?
                       User.find_by(remember_token: cookies.permanent.encrypted[:remember_token])
                     end
  end

  def log_in_as(user)
    post login_path, params: { user: { email: user.email, password: user.password } }
  end

  def log_out
    delete logout_path
  end
end
