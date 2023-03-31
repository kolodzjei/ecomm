# frozen_string_literal: true

require "rails_helper"

RSpec.describe("Categories", type: :request) do
  let(:user) { create(:user) }
  let(:admin) { create(:admin) }
  let(:category) { create(:category) }
  describe "GET /categories" do
    it "redirects to login page if not logged in" do
      get categories_path
      expect(response).to(redirect_to(login_path))
    end

    it "redirects to root if not admin" do
      login_as user
      get categories_path
      expect(response).to(redirect_to(root_path))
    end

    it "returns http success if admin" do
      login_as admin
      get categories_path
      expect(response).to(have_http_status(:success))
    end
  end

  describe "GET /categories/new" do
    it "redirects to login page if not logged in" do
      get new_category_path
      expect(response).to(redirect_to(login_path))
    end

    it "redirects to root if not admin" do
      login_as user
      get new_category_path
      expect(response).to(redirect_to(root_path))
    end

    it "returns http success if admin" do
      login_as admin
      get new_category_path
      expect(response).to(have_http_status(:success))
    end
  end

  describe "POST /categories" do
    it "redirects to login page if not logged in" do
      post categories_path
      expect(response).to(redirect_to(login_path))
    end

    it "redirects to root if not admin" do
      login_as user
      post categories_path
      expect(response).to(redirect_to(root_path))
    end

    it "creates a category if admin" do
      login_as admin
      post categories_path, params: { category: { name: "test" } }
      expect(response).to(redirect_to(categories_path))
      expect(Category.last.name).to(eq("test"))
    end
  end

  describe "GET /categories/:id/edit" do
    it "redirects to login page if not logged in" do
      get edit_category_path(category)
      expect(response).to(redirect_to(login_path))
    end

    it "redirects to root if not admin" do
      login_as user
      get edit_category_path(category)
      expect(response).to(redirect_to(root_path))
    end

    it "returns http success if admin" do
      login_as admin
      get edit_category_path(category)
      expect(response).to(have_http_status(:success))
    end
  end

  describe "PATCH /categories/:id" do
    it "redirects to login page if not logged in" do
      patch category_path(category)
      expect(response).to(redirect_to(login_path))
    end

    it "does not update a category if not logged in" do
      expect do
        patch(category_path(category), params: { category: { name: "test2" } })
      end.to_not(change { category.name })
    end

    it "redirects to root if not admin" do
      login_as user
      patch category_path(category)
      expect(response).to(redirect_to(root_path))
    end

    it "does not update a category if not admin" do
      category
      login_as user
      expect do
        patch(category_path(category), params: { category: { name: "test2" } })
      end.to_not(change { category.name })
    end

    it "redirects to categories if admin" do
      category
      login_as admin
      patch category_path(category), params: { category: { name: "test2" } }
      expect(response).to(redirect_to(categories_path))
    end

    it "updates a category if admin" do
      category
      login_as admin
      expect do
        patch(category_path(category), params: { category: { name: "test2" } })
      end.to(change { category.reload.name }.from("Test category").to("test2"))
    end
  end

  describe "DELETE /categories/:id" do
    it "redirects to login page if not logged in" do
      delete category_path(category)
      expect(response).to(redirect_to(login_path))
    end

    it "does not delete a category if not logged in" do
      category
      expect { delete(category_path(category)) }.to_not(change(Category, :count))
    end

    it "redirects to root if not admin" do
      login_as user
      delete category_path(category)
      expect(response).to(redirect_to(root_path))
    end

    it "does not delete a category if not admin" do
      category
      login_as user
      expect { delete(category_path(category)) }.to_not(change(Category, :count))
    end

    it "redirects to categories if admin" do
      login_as admin
      delete category_path(category)
      expect(response).to(redirect_to(categories_path))
    end

    it "deletes a category if admin" do
      category
      login_as admin
      expect { delete(category_path(category)) }.to(change(Category, :count).by(-1))
    end
  end
end
