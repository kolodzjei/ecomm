# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admin::Dashboards', type: :request do
  let(:user) { create(:user) }
  let(:admin) { create(:admin) }

  it 'should redirect to login page if not logged in' do
    get admin_dashboard_path
    expect(response).to redirect_to(login_path)
  end

  it 'should redirect to root page if logged in as user' do
    login_as user
    get admin_dashboard_path
    expect(response).to redirect_to(root_path)
  end

  it 'returns http success if logged in as admin' do
    login_as admin
    get admin_dashboard_path
    expect(response).to have_http_status(:success)
  end
end
