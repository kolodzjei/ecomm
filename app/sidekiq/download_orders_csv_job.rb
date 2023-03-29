# frozen_string_literal: true

require 'csv'

class DownloadOrdersCsvJob
  include Sidekiq::Job
  include Sidekiq::Status::Worker

  def perform(start_date, end_date)
    start_date = Date.parse(start_date)
    end_date = Date.parse(end_date)

    orders = Order.where(created_at: start_date.beginning_of_day..end_date.end_of_day)

    csv_data = CSV.generate do |csv|
      csv << ['Order ID', 'Order Date', 'Order Status', 'Order Total', 'Customer']
      orders.each do |order|
        csv << [order.id, order.created_at, order.status, order.total, order.user.email]
      end
    end

    file_path = Rails.root.join('tmp', "orders#{jid}.csv")
    File.open(file_path, 'w') { |file| file.write(csv_data) }
  end
end
