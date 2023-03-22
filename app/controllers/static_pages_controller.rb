# frozen_string_literal: true

class StaticPagesController < ApplicationController
  def home
    @products = Product.all
  end
end
