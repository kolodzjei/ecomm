# frozen_string_literal: true

require "rails_helper"

RSpec.feature("UsersLogin", type: :feature) do
  scenario "login with invalid information" do
    visit login_path
    fill_in "E-mail", with: ""
    fill_in "Password", with: ""
    click_button "Log in"
    expect(page).to(have_content("Invalid email or password."))
    visit root_path
    expect(page).not_to(have_content("Invalid email or password."))
  end

  scenario "login with valid information followed by logout" do
    user = create(:user)
    visit login_path
    fill_in "E-mail", with: user.email
    fill_in "Password", with: user.password
    click_button "Log in"
    expect(page).to(have_content("You are now logged in."))
    expect(page).to(have_link("Log out"))
    click_link "Log out"
    expect(page).to(have_content("You are now logged out."))
    expect(page).not_to(have_link("Log out"))
  end
end
