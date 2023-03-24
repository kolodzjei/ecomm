# frozen_string_literal: true

class StaticPagesController < ApplicationController
  def home
    all = Product.all
    if params[:category_ids].present?
      category_ids = params[:category_ids].map(&:to_i)
      all = all.by_category(category_ids)
    end
    @pagy, @products = pagy(all, items: 9)
  end
end
