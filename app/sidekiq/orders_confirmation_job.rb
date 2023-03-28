# frozen_string_literal: true

class OrdersConfirmationJob
  include Sidekiq::Job

  def perform(order_id)
    order = Order.find_by(id: order_id)
    return unless order

    OrderConfirmationMailer.confirmation(order).deliver_now
  end
end
