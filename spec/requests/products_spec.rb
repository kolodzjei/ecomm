# frozen_string_literal: true

require "rails_helper"

RSpec.describe("Products", type: :request) do
  let(:admin) { create(:admin) }
  let(:user) { create(:user) }
  let(:product) { create(:product) }

  describe "GET /products" do
    it "renders for admin" do
      login_as admin
      get products_path
      expect(response).to(have_http_status(200))
    end

    it "redirects for user" do
      login_as user
      get products_path
      expect(response).to(have_http_status(302))
    end

    it "redirects for guest" do
      get products_path
      expect(response).to(have_http_status(302))
    end
  end

  describe "GET /products/new" do
    it "renders for admin" do
      login_as admin
      get new_product_path
      expect(response).to(have_http_status(200))
    end

    it "redirects for user" do
      login_as user
      get new_product_path
      expect(response).to(have_http_status(302))
    end

    it "redirects for guest" do
      get new_product_path
      expect(response).to(have_http_status(302))
    end
  end

  describe "POST /products" do
    it "creates for admin" do
      login_as admin
      expect do
        post(products_path, params: { product: { name: "Test", description: "Test", price: 1 } })
      end.to(change(Product, :count).by(1))
      expect(response).to(have_http_status(302))
    end

    it "redirects for user" do
      login_as user
      expect do
        post(products_path, params: { product: { name: "Test", description: "Test", price: 1 } })
      end.to(change(Product, :count).by(0))
      expect(response).to(have_http_status(302))
    end

    it "redirects for guest" do
      expect do
        post(products_path, params: { product: { name: "Test", description: "Test", price: 1 } })
      end.to(change(Product, :count).by(0))

      expect(response).to(have_http_status(302))
    end
  end

  describe "GET /products/:id/edit" do
    it "renders for admin" do
      login_as admin
      get edit_product_path(product)
      expect(response).to(have_http_status(200))
    end

    it "redirects for user" do
      login_as user
      get edit_product_path(product)
      expect(response).to(have_http_status(302))
    end

    it "redirects for guest" do
      get edit_product_path(product)
      expect(response).to(have_http_status(302))
    end
  end

  describe "PATCH /products/:id" do
    it "updates for admin" do
      login_as admin

      name = "Test"
      description = "Test"
      price = 1

      patch product_path(product), params: { product: { name:, description:, price: } }

      product.reload
      expect(product.name).to(eq(name))
      expect(product.description).to(eq(description))
      expect(product.price).to(eq(price))
      expect(response).to(have_http_status(302))
    end

    it "redirects for user" do
      login_as user

      name = "Test"
      description = "Test"
      price = 1
      patch product_path(product), params: { product: { name:, description:, price: } }

      product.reload
      expect(product.name).to_not(eq(name))
      expect(product.description).to_not(eq(description))
      expect(product.price).to_not(eq(price))

      expect(response).to(have_http_status(302))
    end

    it "redirects for guest" do
      name = "Test"
      description = "Test"
      price = 1

      patch product_path(product), params: { product: { name:, description:, price: } }

      product.reload
      expect(product.name).to_not(eq(name))
      expect(product.description).to_not(eq(description))
      expect(product.price).to_not(eq(price))
      expect(response).to(have_http_status(302))
    end
  end

  describe "DELETE /products/:id" do
    before :each do
      product
    end

    it "deletes for admin" do
      login_as admin
      expect do
        delete(product_path(product))
      end.to(change(Product, :count).by(-1))
      expect(response).to(have_http_status(302))
    end

    it "redirects for user" do
      login_as user
      expect do
        delete(product_path(product))
      end.to(change(Product, :count).by(0))
      expect(response).to(have_http_status(302))
    end

    it "redirects for guest" do
      expect do
        delete(product_path(product))
      end.to(change(Product, :count).by(0))
      expect(response).to(have_http_status(302))
    end
  end

  describe "GET /products/:id" do
    it "renders for user" do
      login_as user
      get product_path(product)
      expect(response).to(have_http_status(200))
    end

    it "redirects for guest" do
      get product_path(product)
      expect(response).to(have_http_status(302))
    end
  end
end
