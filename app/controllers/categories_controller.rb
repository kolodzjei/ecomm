# frozen_string_literal: true

class CategoriesController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_admin!

  def index
    @pagy, @categories = pagy(Category.all, items: 20)
  end

  def new
    @category = Category.new
  end

  def edit
    @category = Category.find_by(id: params[:id])
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      flash[:success] = 'Category created successfully'
    else
      flash[:danger] = 'Category not created'
    end
    redirect_to categories_path
  end

  def destroy
    @category = Category.find_by(id: params[:id])
    @category.destroy
    flash[:success] = 'Category deleted successfully'
    redirect_to categories_path
  end

  def update
    @category = Category.find_by(id: params[:id])
    if @category.update(category_params)
      flash[:success] = 'Category updated successfully'
      redirect_to categories_path
    else
      flash[:danger] = 'Category not updated'
      render 'edit'
    end
  end

  private

  def category_params
    params.require(:category).permit(:name)
  end
end
