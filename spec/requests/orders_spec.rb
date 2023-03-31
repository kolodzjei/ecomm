# frozen_string_literal: true

require "rails_helper"

RSpec.describe("Orders", type: :request) do
  let(:user) { create(:user) }
  let(:product) { create(:product) }
  let(:item) { create(:item, :with_specific_user_and_product, cart_id: user.cart.id, product_id: product.id) }
  let(:order) do
    create(
      :order,
      :with_specific_user_and_items,
      user_id: user.id,
      items: [item],
    )
  end
  describe "GET /orders/new" do
    it "redirects to login page when user is not logged in" do
      get new_order_path
      expect(response).to(redirect_to(login_path))
    end

    describe "when user is logged in" do
      it "redirects if cart is empty" do
        login_as user
        get new_order_path
        expect(response).to(redirect_to(root_path))
      end

      it "renders successfuly if cart is not empty" do
        login_as user
        create(:item, :with_specific_user_and_product, cart_id: user.cart.id, product_id: product.id)
        get new_order_path
        expect(response).to(have_http_status(:success))
      end
    end
  end

  describe "POST /orders" do
    it "redirects to login page when user is not logged in" do
      post orders_path
      expect(response).to(redirect_to(login_path))
    end

    it "redirects to root page if cart is empty" do
      login_as user
      post orders_path
      expect(response).to(redirect_to(root_path))
    end

    it "creates an order if cart is not empty" do
      login_as user
      create(:item, :with_specific_user_and_product, cart_id: user.cart.id, product_id: product.id)
      post orders_path(params: {
        order: {
          shipping_name: "John Doe",
          shipping_address_line_1: "123 Main St",
          shipping_address_line_2: "Apt 1",
          shipping_city: "New York",
          shipping_zipcode: "12345",
          shipping_country: "USA",
        },
      })
      expect(response).to(redirect_to(order_path(Order.last.id)))
    end
  end

  describe "GET /orders/:id" do
    it "redirects to login page when user is not logged in" do
      get order_path(order.id)
      expect(response).to(redirect_to(login_path))
    end

    it "redirects to root page if order does not exist" do
      login_as user
      get order_path(-1)
      expect(response).to(redirect_to(root_path))
    end

    it "renders successfuly if order exists and user is owner" do
      login_as user
      get order_path(order.id)
      expect(response).to(have_http_status(:success))
    end

    it "renders successfuly if order exists and user is admin" do
      order
      login_as create(:admin)
      get order_path(order.id)
      expect(response).to(have_http_status(:success))
    end

    it "redirects to root page if order exists and user is not owner or admin" do
      order
      login_as create(:user2)
      get order_path(order.id)
      expect(response).to(redirect_to(root_path))
    end
  end

  describe "GET /orders" do
    it "redirects to login page when user is not logged in" do
      get orders_path
      expect(response).to(redirect_to(login_path))
    end

    it "redirects to root page if user is not admin" do
      login_as user
      get orders_path
      expect(response).to(redirect_to(root_path))
    end

    it "renders successfuly if user is admin" do
      login_as create(:admin)
      get orders_path
      expect(response).to(have_http_status(:success))
    end
  end

  describe "DELETE /orders/:id/cancel" do
    it "redirects to login page when user is not logged in" do
      order
      delete cancel_order_path(order.id)
      expect(response).to(redirect_to(login_path))
    end

    it "redirects to root page if order does not exist" do
      login_as user
      delete cancel_order_path(-1)
      expect(response).to(redirect_to(root_path))
    end

    it "redirects to root page if order exists and user is not owner or admin" do
      order
      login_as create(:user2)
      delete cancel_order_path(order.id)
      expect(response).to(redirect_to(root_path))
    end

    it "redirects to order page if order exists and user is owner" do
      login_as user
      order
      delete cancel_order_path(order.id)
      expect(response).to(redirect_to(order_path(order.id)))
    end

    it "redirects to order page if order exists and user is admin" do
      order
      login_as create(:admin)
      delete cancel_order_path(order.id)
      expect(response).to(redirect_to(order_path(order.id)))
    end

    it "redirects to root if user cancels not pending order" do
      login_as user
      order
      order.update_attribute(:status, "shipped")
      delete cancel_order_path(order.id)
      expect(response).to(redirect_to(root_path))
    end

    # it 'redirects to order page if admin cancels not pending order' do
    #   order
    #   login_as create(:admin)
    #   delete cancel_order_path(order)
    #   expect(order.status).to eq('cancelled')
    #   expect(response).to redirect_to(order_path(order))
    # end
  end

  describe "POST /orders/:id/ship" do
    it "redirects to login page when user is not logged in" do
      post ship_order_path(-1)
      expect(response).to(redirect_to(login_path))
    end

    it "redirects to root page if order does not exist" do
      login_as user
      post ship_order_path(-1)
      expect(response).to(redirect_to(root_path))
    end

    it "redirects to root page if order exists and user is not admin" do
      order
      login_as user
      post ship_order_path(order.id)
      expect(Order.first.status).to(eq("pending"))
      expect(response).to(redirect_to(root_path))
    end

    it "redirects to order page if order exists and user is admin" do
      order
      login_as create(:admin)
      post ship_order_path(order.id)
      expect(Order.first.status).to(eq("shipped"))
      expect(response).to(redirect_to(order_path(order.id)))
    end
  end

  describe "GET /orders/:id/pay" do
    it "redirects to login page when user is not logged in" do
      get pay_order_path(-1)
      expect(response).to(redirect_to(login_path))
    end

    it "redirects to root if order does not exist" do
      login_as user
      get pay_order_path(-1)
      expect(response).to(redirect_to(root_path))
    end

    it "redirects to root if order exists and user is not owner" do
      order
      login_as create(:user2)
      get pay_order_path(order.id)
      expect(response).to(redirect_to(root_path))
    end

    it "redirects if order is not pending and user is owner" do
      order
      order.update_attribute(:status, "shipped")
      login_as user
      get pay_order_path(order.id)
      expect(response).to(redirect_to(order_path(order.id)))
    end

    it "renders pay page if order is pending and user is owner" do
      login_as user
      order
      get pay_order_path(order.id)
      expect(response).to(have_http_status(:success))
    end
  end

  describe "POST /orders/:id/pay" do
    it "redirects to login page when user is not logged in" do
      post paid_order_path(-1)
      expect(response).to(redirect_to(login_path))
    end

    it "redirects to root if order does not exist" do
      login_as user
      post paid_order_path(-1)
      expect(response).to(redirect_to(root_path))
    end

    it "redirects to root if order exists and user is not owner" do
      order
      login_as create(:user2)
      post paid_order_path(order)
      expect(response).to(redirect_to(root_path))
    end

    it "redirects if order is not pending and user is owner" do
      login_as user
      order
      post paid_order_path(order)
      expect(response).to(redirect_to(order_path(order)))
    end
  end

  describe "POST /orders/:id/receive" do
    it "redirects to login page when user is not logged in" do
      post receive_order_path(-1)
      expect(response).to(redirect_to(login_path))
    end

    it "redirects to root if order does not exist" do
      login_as user
      post receive_order_path(-1)
      expect(response).to(redirect_to(root_path))
    end

    it "redirects to order if user is owner and marks it as received" do
      login_as user
      order
      post receive_order_path(order)
      expect(Order.first.status).to(eq("received"))
      expect(response).to(redirect_to(order_path(order)))
    end

    it "redirects to order if user is admin and marks it as received" do
      order
      login_as create(:admin)
      post receive_order_path(order)
      expect(Order.first.status).to(eq("received"))
      expect(response).to(redirect_to(order_path(order)))
    end

    it "redirects to root if user is not owner or admin" do
      order
      login_as create(:user2)
      post receive_order_path(order)
      expect(response).to(redirect_to(root_path))
    end
  end
end
