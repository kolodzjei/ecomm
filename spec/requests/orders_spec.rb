# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Orders', type: :request do
  describe 'GET /orders/new' do
    it 'redirects to login page when user is not logged in' do
      get new_order_path
      expect(response).to redirect_to(login_path)
    end

    describe 'when user is logged in' do
      it 'redirects if cart is empty' do
        log_in_user
        get new_order_path
        expect(response).to redirect_to(root_path)
      end

      it 'renders successfuly if cart is not empty' do
        log_in_user
        create(:product)
        Item.create(product_id: 1, cart_id: 1, quantity: 1)
        get new_order_path
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe 'POST /orders' do
    it 'redirects to login page when user is not logged in' do
      post orders_path
      expect(response).to redirect_to(login_path)
    end

    it 'redirects to root page if cart is empty' do
      log_in_user
      post orders_path
      expect(response).to redirect_to(root_path)
    end

    it 'creates an order if cart is not empty' do
      log_in_user
      create(:product)
      Item.create(product_id: 1, cart_id: 1, quantity: 1)
      post orders_path params: { order: { shipping_name: 'John Doe', shipping_address_line_1: '123 Main St',
                                          shipping_address_line_2: 'Apt 1', shipping_city: 'New York', shipping_zipcode: '12345', shipping_country: 'USA' } }
      expect(response).to redirect_to(order_path(1))
    end
  end

  describe 'GET /orders/:id' do
    it 'redirects to login page when user is not logged in' do
      get order_path(1)
      expect(response).to redirect_to(login_path)
    end

    it 'redirects to root page if order does not exist' do
      log_in_user
      get order_path(1)
      expect(response).to redirect_to(root_path)
    end

    it 'renders successfuly if order exists and user is owner' do
      log_in_user
      create(:product)
      Item.create(product_id: 1, cart_id: 1, quantity: 1)
      Order.create(user_id: 1, shipping_name: 'John Doe', shipping_address_line_1: '123 Main St',
                   shipping_address_line_2: 'Apt 1', shipping_city: 'New York', shipping_zipcode: '12345', shipping_country: 'USA')
      get order_path(1)
      expect(response).to have_http_status(:success)
    end

    it 'renders successfuly if order exists and user is admin' do
      create(:user)
      create(:product)
      Item.create(product_id: 1, cart_id: 1, quantity: 1)
      Order.create(user_id: 1, shipping_name: 'John Doe', shipping_address_line_1: '123 Main St',
                   shipping_address_line_2: 'Apt 1', shipping_city: 'New York', shipping_zipcode: '12345', shipping_country: 'USA')
      log_in_admin
      get order_path(1)
      expect(response).to have_http_status(:success)
    end

    it 'redirects to root page if order exists and user is not owner or admin' do
      user = create(:admin)
      create(:product)
      Item.create(product_id: 1, cart_id: 1, quantity: 1)
      Order.create(user_id: 1, shipping_name: 'John Doe', shipping_address_line_1: '123 Main St',
                   shipping_address_line_2: 'Apt 1', shipping_city: 'New York', shipping_zipcode: '12345', shipping_country: 'USA')
      log_in_user
      get order_path(1)
      expect(response).to redirect_to(root_path)
    end
  end

  describe 'GET /orders' do
    it 'redirects to login page when user is not logged in' do
      get orders_path
      expect(response).to redirect_to(login_path)
    end

    it 'redirects to root page if user is not admin' do
      log_in_user
      get orders_path
      expect(response).to redirect_to(root_path)
    end

    it 'renders successfuly if user is admin' do
      log_in_admin
      get orders_path
      expect(response).to have_http_status(:success)
    end
  end

  describe 'DELETE /orders/:id/cancel' do
    it 'redirects to login page when user is not logged in' do
      delete cancel_order_path(1)
      expect(response).to redirect_to(login_path)
    end

    it 'redirects to root page if order does not exist' do
      log_in_user
      delete cancel_order_path(1)
      expect(response).to redirect_to(root_path)
    end

    it 'redirects to root page if order exists and user is not owner or admin' do
      user = create(:admin)
      create(:product)
      Item.create(product_id: 1, cart_id: 1, quantity: 1)
      Order.create(user_id: 1, shipping_name: 'John Doe', shipping_address_line_1: '123 Main St',
                   shipping_address_line_2: 'Apt 1', shipping_city: 'New York', shipping_zipcode: '12345', shipping_country: 'USA')
      log_in_user
      delete cancel_order_path(1)
      expect(response).to redirect_to(root_path)
    end

    it 'redirects to order page if order exists and user is owner' do
      log_in_user
      create(:product)
      Item.create(product_id: 1, cart_id: 1, quantity: 1)
      Order.create(user_id: 1, shipping_name: 'John Doe', shipping_address_line_1: '123 Main St',
                   shipping_address_line_2: 'Apt 1', shipping_city: 'New York', shipping_zipcode: '12345', shipping_country: 'USA')
      delete cancel_order_path(1)
      expect(response).to redirect_to(order_path(1))
    end

    it 'redirects to order page if order exists and user is admin' do
      create(:user)
      create(:product)
      Item.create(product_id: 1, cart_id: 1, quantity: 1)
      Order.create(user_id: 1, shipping_name: 'John Doe', shipping_address_line_1: '123 Main St',
                   shipping_address_line_2: 'Apt 1', shipping_city: 'New York', shipping_zipcode: '12345', shipping_country: 'USA')
      log_in_admin
      delete cancel_order_path(1)
      expect(response).to redirect_to(order_path(1))
    end

    it 'redirects to root if user cancels not pending order' do
      log_in_user
      create(:product)
      Item.create(product_id: 1, cart_id: 1, quantity: 1)
      Order.create(user_id: 1, shipping_name: 'John Doe', shipping_address_line_1: '123 Main St',
                   shipping_address_line_2: 'Apt 1', shipping_city: 'New York', shipping_zipcode: '12345', shipping_country: 'USA', status: 'shipped')
      delete cancel_order_path(1)
      expect(response).to redirect_to(root_path)
    end

    # it 'redirects to order page if admin cancels not pending order' do
    #   create(:user)
    #   create(:product)
    #   Item.create(product_id: 1, cart_id: 1, quantity: 1)
    #   order = Order.create(user_id: 1, shipping_name: 'John Doe', shipping_address_line_1: '123 Main St', shipping_address_line_2: 'Apt 1', shipping_city: 'New York', shipping_zipcode: '12345', shipping_country: 'USA', status: 'shipped')
    #   log_in_admin
    #   delete cancel_order_path(order)
    #   expect(order.status).to eq('cancelled')
    #   expect(response).to redirect_to(order_path(order))
    # end
  end

  describe 'POST /orders/:id/ship' do
    it 'redirects to login page when user is not logged in' do
      post ship_order_path(1)
      expect(response).to redirect_to(login_path)
    end

    it 'redirects to root page if order does not exist' do
      log_in_user
      post ship_order_path(1)
      expect(response).to redirect_to(root_path)
    end

    it 'redirects to root page if order exists and user is not admin' do
      log_in_user
      create(:product)
      Item.create(product_id: 1, cart_id: 1, quantity: 1)
      Order.create(user_id: 1, shipping_name: 'John Doe', shipping_address_line_1: '123 Main St',
                   shipping_address_line_2: 'Apt 1', shipping_city: 'New York', shipping_zipcode: '12345', shipping_country: 'USA')
      post ship_order_path(1)
      expect(Order.first.status).to eq('pending')
      expect(response).to redirect_to(root_path)
    end

    it 'redirects to order page if order exists and user is admin' do
      create(:user)
      create(:product)
      Item.create(product_id: 1, cart_id: 1, quantity: 1)
      Order.create(user_id: 1, shipping_name: 'John Doe', shipping_address_line_1: '123 Main St',
                   shipping_address_line_2: 'Apt 1', shipping_city: 'New York', shipping_zipcode: '12345', shipping_country: 'USA')
      log_in_admin
      post ship_order_path(1)
      expect(Order.first.status).to eq('shipped')
      expect(response).to redirect_to(order_path(1))
    end
  end

  describe 'GET /orders/:id/pay' do
    it 'redirects to login page when user is not logged in' do
      get pay_order_path(1)
      expect(response).to redirect_to(login_path)
    end

    it 'redirects to root if order does not exist' do
      log_in_user
      get pay_order_path(1)
      expect(response).to redirect_to(root_path)
    end

    it 'redirects to root if order exists and user is not owner' do
      create(:admin)
      create(:product)
      Item.create(product_id: 1, cart_id: 1, quantity: 1)
      Order.create(user_id: 1, shipping_name: 'John Doe', shipping_address_line_1: '123 Main St',
                   shipping_address_line_2: 'Apt 1', shipping_city: 'New York', shipping_zipcode: '12345', shipping_country: 'USA')
      log_in_user
      get pay_order_path(1)
      expect(response).to redirect_to(root_path)
    end

    it 'redirects if order is not pending and user is owner' do
      log_in_user
      create(:product)
      Item.create(product_id: 1, cart_id: 1, quantity: 1)
      Order.create(user_id: 1, shipping_name: 'John Doe', shipping_address_line_1: '123 Main St',
                   shipping_address_line_2: 'Apt 1', shipping_city: 'New York', shipping_zipcode: '12345', shipping_country: 'USA', status: 'shipped')
      get pay_order_path(1)
      expect(response).to redirect_to(order_path(1))
    end

    it 'renders pay page if order is pending and user is owner' do
      log_in_user
      create(:product)
      Item.create(product_id: 1, cart_id: 1, quantity: 1)
      Order.create(user_id: 1, shipping_name: 'John Doe', shipping_address_line_1: '123 Main St',
                   shipping_address_line_2: 'Apt 1', shipping_city: 'New York', shipping_zipcode: '12345', shipping_country: 'USA')
      get pay_order_path(1)
      expect(response).to have_http_status(:success)
    end
  end

  describe 'POST /orders/:id/pay' do
    it 'redirects to login page when user is not logged in' do
      post paid_order_path(1)
      expect(response).to redirect_to(login_path)
    end

    it 'redirects to root if order does not exist' do
      log_in_user
      post paid_order_path(1)
      expect(response).to redirect_to(root_path)
    end

    it 'redirects to root if order exists and user is not owner' do
      create(:admin)
      create(:product)
      Item.create(product_id: 1, cart_id: 1, quantity: 1)
      Order.create(user_id: 1, shipping_name: 'John Doe', shipping_address_line_1: '123 Main St',
                   shipping_address_line_2: 'Apt 1', shipping_city: 'New York', shipping_zipcode: '12345', shipping_country: 'USA')
      log_in_user
      post paid_order_path(1)
      expect(response).to redirect_to(root_path)
    end

    it 'redirects if order is not pending and user is owner' do
      log_in_user
      create(:product)
      Item.create(product_id: 1, cart_id: 1, quantity: 1)
      Order.create(user_id: 1, shipping_name: 'John Doe', shipping_address_line_1: '123 Main St',
                   shipping_address_line_2: 'Apt 1', shipping_city: 'New York', shipping_zipcode: '12345', shipping_country: 'USA', status: 'shipped')
      post paid_order_path(1)
      expect(response).to redirect_to(order_path(1))
    end
  end

  describe 'POST /orders/:id/receive' do
    it 'redirects to login page when user is not logged in' do
      post receive_order_path(1)
      expect(response).to redirect_to(login_path)
    end

    it 'redirects to root if order does not exist' do
      log_in_user
      post receive_order_path(1)
      expect(response).to redirect_to(root_path)
    end

    it 'redirects to order if user is owner and marks it as received' do
      log_in_user
      create(:product)
      Item.create(product_id: 1, cart_id: 1, quantity: 1)
      Order.create(user_id: 1, shipping_name: 'John Doe', shipping_address_line_1: '123 Main St',
                   shipping_address_line_2: 'Apt 1', shipping_city: 'New York', shipping_zipcode: '12345', shipping_country: 'USA')
      post receive_order_path(1)
      expect(Order.first.status).to eq('received')
      expect(response).to redirect_to(order_path(1))
    end

    it 'redirects to order if user is admin and marks it as received' do
      create(:user)
      create(:product)
      Item.create(product_id: 1, cart_id: 1, quantity: 1)
      Order.create(user_id: 1, shipping_name: 'John Doe', shipping_address_line_1: '123 Main St',
                   shipping_address_line_2: 'Apt 1', shipping_city: 'New York', shipping_zipcode: '12345', shipping_country: 'USA')
      log_in_admin
      post receive_order_path(1)
      expect(Order.first.status).to eq('received')
      expect(response).to redirect_to(order_path(1))
    end
  end
end
