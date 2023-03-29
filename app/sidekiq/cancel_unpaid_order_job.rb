class CancelUnpaidOrderJob
  include Sidekiq::Job

  def perform(order_id)
    order = Order.find_by(id: order_id)
    return if order.paid?

    order.cancel!
  end
end
