# frozen_string_literal: true

require "rails_helper"

RSpec.feature("Categories", type: :feature) do
  before do
    user = create(:admin)
    visit login_path
    fill_in "E-mail", with: user.email
    fill_in "Password", with: user.password
    click_button "Log in"
  end

  scenario "admin can create a new category" do
    visit new_category_path
    fill_in "Name", with: "Test Category"
    click_button "Create Category"
    expect(page).to(have_content("Category created successfully"))
    expect(page).to(have_content("Test Category"))
  end

  scenario "admin can edit a category" do
    category = create(:category)
    visit edit_category_path(category)
    fill_in "Name", with: "Test"
    click_button "Update Category"
    expect(page).to(have_content("Category updated successfully"))
    expect(page).to(have_content("Test"))
  end

  scenario "admin can delete a category" do
    create(:category)
    visit categories_path
    click_link "Delete"
    expect(page).to(have_content("Category deleted successfully"))
    expect(page).not_to(have_content("Test"))
  end
end
