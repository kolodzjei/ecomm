# frozen_string_literal: true

module Admin
  class OrdersSummaryController < ApplicationController
    before_action :authenticate_user!
    before_action :authenticate_admin!

    def index
      start_date = params[:start_date].present? ? Date.parse(params[:start_date]) : Date.today.beginning_of_month
      end_date = params[:end_date].present? ? Date.parse(params[:end_date]) : Date.today.end_of_month
      @orders = Order.where(created_at: start_date.beginning_of_day..end_date.end_of_day)
      @cancelled_orders = @orders.where(status: "cancelled")
      @pending_orders = @orders.where(status: "pending")
      @other_orders = @orders.where.not(status: ["cancelled", "pending"])
    end

    def download_csv
      start_date = params[:start_date].present? ? params[:start_date] : Date.today.beginning_of_month.to_s
      end_date = params[:end_date].present? ? params[:end_date] : Date.today.end_of_month.to_s

      job_id = DownloadOrdersCsvJob.perform_async(start_date, end_date)
      render(json: { job_id: })
    end

    def check_job_status
      job_id = params[:job_id]
      if Sidekiq::Status.complete?(job_id)
        download_url = Rails.application.routes.url_helpers.admin_download_orders_csv_path(job_id:)
        file_path = Rails.root.join("tmp", "orders#{job_id}.csv")
        DeleteFileJob.perform_in(1.minute, file_path.to_s)
        render(json: { status: "complete", download_url: })
      else
        render(json: { status: "in_progress" })
      end
    end

    def download_orders_csv
      job_id = params[:job_id]
      file_path = Rails.root.join("tmp", "orders#{job_id}.csv")
      send_file(file_path, type: "text/csv", filename: "orders#{job_id}.csv")
    end
  end
end
