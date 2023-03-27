# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admin::Dashboards', type: :request do
  it 'should redirect to login page if not logged in' do
    get admin_dashboard_path
    expect(response).to redirect_to(login_path)
  end

  it 'should redirect to root page if logged in as user' do
    log_in_user
    get admin_dashboard_path
    expect(response).to redirect_to(root_path)
  end

  it 'returns http success if logged in as admin' do
    log_in_admin
    get admin_dashboard_path
    expect(response).to have_http_status(:success)
  end
end
