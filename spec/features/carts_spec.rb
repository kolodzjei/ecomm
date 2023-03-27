# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Carts', type: :feature do
  before do
    @product = create(:product)
    @user = create(:user)
    visit login_path
    fill_in 'E-mail', with: @user.email
    fill_in 'Password', with: @user.password
    click_button 'Log in'
  end

  scenario 'user can add product to cart' do
    visit product_path(@product)
    click_on 'Add to cart'
    expect(page).to have_content 'Item added to cart'
    expect(page).to have_content @product.name
  end

  scenario 'user can remove product from cart' do
    visit product_path(@product)
    click_on 'Add to cart'
    click_on '-'
    expect(page).to_not have_content @product.name
  end

  scenario 'user can increase quantity of product in cart' do
    visit product_path(@product)
    click_on 'Add to cart'
    click_on '+'
    expect(page).to have_content '2'
  end

  scenario 'user can decrease quantity of product in cart' do
    visit product_path(@product)
    click_on 'Add to cart'
    click_on '+'
    click_on '-'
    expect(page).to have_content '1'
  end
end
