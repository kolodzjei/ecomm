# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'ProductsFilter', type: :feature do
  let(:user) { create(:user) }

  before do
    visit login_path
    fill_in 'E-mail', with: user.email
    fill_in 'Password', with: user.password
    click_button 'Log in'
    @category = create(:category)
    @product1 = create(:random_product)
    @product1.categories << @category
    @product2 = create(:random_product)
    @product3 = create(:random_product)
  end

  scenario 'user can filter products by categories' do
    visit root_path
    expect(page).to have_content @product1.name
    expect(page).to have_content @product2.name
    expect(page).to have_content @product3.name
    check @category.name
    click_on 'Filter'
    expect(page).to have_content @product1.name
    expect(page).to_not have_content @product2.name
    expect(page).to_not have_content @product3.name
  end

  scenario 'user can search products by name' do
    visit root_path
    expect(page).to have_content @product1.name
    expect(page).to have_content @product2.name
    expect(page).to have_content @product3.name
    fill_in 'Search products...', with: @product1.name
    click_on 'Search'
    expect(page).to have_content @product1.name
    expect(page).to_not have_content @product2.name
    expect(page).to_not have_content @product3.name
  end
end
