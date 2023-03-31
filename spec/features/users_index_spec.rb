# frozen_string_literal: true

require "rails_helper"

RSpec.describe("UsersIndex", type: :feature) do
  let(:admin) { create(:admin) }

  before do
    visit login_path
    fill_in "E-mail", with: admin.email
    fill_in "Password", with: admin.password
    click_button "Log in"
  end

  scenario "admin can block and unlock user acconunts" do
    create(:random_user)
    visit users_path
    click_on "Disable"
    expect(page).to(have_content("User disabled"))
    expect(page).to(have_content("Enable"))
    click_on "Enable"
    expect(page).to(have_content("User unlocked"))
    expect(page).to(have_content("Disable"))
  end
end
