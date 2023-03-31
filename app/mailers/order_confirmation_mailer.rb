# frozen_string_literal: true

class OrderConfirmationMailer < ApplicationMailer
  def confirmation(order)
    @order = order
    @user = @order.user

    mail(to: @user.email, subject: "Order Confirmation")
  end
end
