# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Categories', type: :request do
  describe 'GET /categories' do
    it 'redirects to login page if not logged in' do
      get categories_path
      expect(response).to redirect_to(login_path)
    end

    it 'redirects to root if not admin' do
      log_in_user
      get categories_path
      expect(response).to redirect_to(root_path)
    end

    it 'returns http success if admin' do
      log_in_admin
      get categories_path
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET /categories/new' do
    it 'redirects to login page if not logged in' do
      get new_category_path
      expect(response).to redirect_to(login_path)
    end

    it 'redirects to root if not admin' do
      log_in_user
      get new_category_path
      expect(response).to redirect_to(root_path)
    end

    it 'returns http success if admin' do
      log_in_admin
      get new_category_path
      expect(response).to have_http_status(:success)
    end
  end

  describe 'POST /categories' do
    it 'redirects to login page if not logged in' do
      post categories_path
      expect(response).to redirect_to(login_path)
    end

    it 'redirects to root if not admin' do
      log_in_user
      post categories_path
      expect(response).to redirect_to(root_path)
    end

    it 'creates a category if admin' do
      log_in_admin
      post categories_path, params: { category: { name: 'test' } }
      expect(response).to redirect_to(categories_path)
      expect(Category.last.name).to eq('test')
    end
  end

  describe 'GET /categories/:id/edit' do
    before :each do
      @category = Category.create(name: 'test')
    end


    it 'redirects to login page if not logged in' do
      get edit_category_path(@category)
      expect(response).to redirect_to(login_path)
    end

    it 'redirects to root if not admin' do
      log_in_user
      get edit_category_path(@category)
      expect(response).to redirect_to(root_path)
    end

    it 'returns http success if admin' do
      log_in_admin
      get edit_category_path(@category)
      expect(response).to have_http_status(:success)
    end
  end

  describe 'PATCH /categories/:id' do
    before :each do
      @category = Category.create(name: 'test')
    end

    it 'redirects to login page if not logged in' do
      patch category_path(@category)
      expect(response).to redirect_to(login_path)
    end

    it 'redirects to root if not admin' do
      log_in_user
      patch category_path(@category)
      expect(response).to redirect_to(root_path)
    end

    it 'updates a category if admin' do
      log_in_admin
      patch category_path(@category), params: { category: { name: 'test2' } }
      expect(response).to redirect_to(categories_path)
      expect(Category.last.name).to eq('test2')
    end
  end

  describe 'DELETE /categories/:id' do
    before :each do
      @category = Category.create(name: 'test')
    end

    it 'redirects to login page if not logged in' do
      delete category_path(@category)
      expect(response).to redirect_to(login_path)
    end

    it 'redirects to root if not admin' do
      log_in_user
      delete category_path(@category)
      expect(response).to redirect_to(root_path)
    end

    it 'deletes a category if admin' do
      log_in_admin
      delete category_path(@category)
      expect(response).to redirect_to(categories_path)
      expect(Category.count).to eq(0)
    end
  end
end
