# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Products', type: :feature do
  before do
    user = create(:admin)
    visit login_path
    fill_in 'E-mail', with: user.email
    fill_in 'Password', with: user.password
    click_button 'Log in'
  end

  scenario 'admin can create a new product' do
    visit new_product_path
    fill_in 'Name', with: 'Test Product'
    fill_in 'Description', with: 'Test Description'
    fill_in 'Price', with: '1.00'
    click_button 'Create product'
    expect(page).to have_content 'Product created'
    expect(page).to have_content 'Test Product'
  end

  scenario 'admin can edit a product' do
    product = create(:product)
    visit edit_product_path(product)
    fill_in 'Name', with: 'Test'
    click_button 'Save changes'
    expect(page).to have_content 'Product updated'
    expect(page).to have_content 'Test'
  end

  scenario 'admin can delete a product' do
    product = create(:product)
    visit products_path
    expect(page).to have_content product.name
    click_link 'Destroy'
    expect(page).to have_content 'Product deleted'
    expect(page).not_to have_content product.name
  end
end
