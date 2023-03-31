# frozen_string_literal: true

require "rails_helper"

RSpec.feature("UsersSignup", type: :feature) do
  scenario "invalid signup information" do
    visit signup_path
    expect do
      click_button("Create account")
    end.not_to(change(User, :count))
    expect(page).to(have_content("error"))
  end

  scenario "valid signup information" do
    visit signup_path
    fill_in "Name", with: "Example User"
    fill_in "E-mail", with: "example@user.com"
    fill_in "Password", with: "foobar"
    fill_in "Password confirmation", with: "foobar"
    click_button "Create account"
    action_mailer = ActionMailer::Base.deliveries.last
    user = User.find_by(email: "example@user.com")

    expect(page).to(have_content("Please check your email for confirmation instructions."))
    expect(page).to(have_link("Log in"))
    expect(action_mailer.to).to(eq(["example@user.com"]))
    expect(action_mailer.subject).to(eq("Confirmation Instructions"))
    expect(user.confirmed_at).to(be_nil)
  end
end
