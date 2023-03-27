# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Orders', type: :feature do
  before do
    @product = create(:product)
    @user = create(:user)
    visit login_path
    fill_in 'E-mail', with: @user.email
    fill_in 'Password', with: @user.password
    click_button 'Log in'
  end

  scenario 'user can place order' do
    visit product_path(@product)
    click_on 'Add to cart'
    click_on 'Proceed to checkout'
    fill_in 'Name', with: 'John'
    fill_in 'Address Line 1', with: '123 Main St'
    fill_in 'City', with: 'New York'
    fill_in 'Zipcode', with: '12345'
    fill_in 'Country', with: 'USA'
    click_on 'Place Order'
    expect(page).to have_content 'Order placed successfully'
    expect(page).to have_content 'pending'
  end

  describe 'user can manage order' do
    before do
      visit product_path(@product)
      click_on 'Add to cart'
      click_on 'Proceed to checkout'
      fill_in 'Name', with: 'John'
      fill_in 'Address Line 1', with: '123 Main St'
      fill_in 'City', with: 'New York'
      fill_in 'Zipcode', with: '12345'
      fill_in 'Country', with: 'USA'
      click_on 'Place Order'
    end

    scenario 'cancel order' do
      click_on 'Cancel order'
      expect(page).to have_content 'Order cancelled successfully'
    end

    scenario 'pay order' do
      click_on 'Pay'
      fill_in 'Card number', with: '4242424242424242'
      fill_in 'CVC', with: '123'
      fill_in 'Expiration month', with: '12'
      fill_in 'Expiration year', with: '2020'
      fill_in 'Name on card', with: 'John Doe'
      click_on 'Pay'
      expect(page).to have_content 'Payment successful'
      expect(page).to have_content 'paid'
    end
  end
end
