# frozen_string_literal: true

class StaticPagesController < ApplicationController
  def home
    all = Product.search(params)
    @pagy, @products = pagy(all, items: 9)
  end
end
