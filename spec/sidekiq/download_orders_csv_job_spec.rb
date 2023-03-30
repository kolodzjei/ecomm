# frozen_string_literal: true

require 'rails_helper'
RSpec.describe DownloadOrdersCsvJob, type: :job do
  describe '#perform' do
    let(:start_date) { Date.today.beginning_of_month.to_s }
    let(:end_date) { Date.today.end_of_month.to_s }
    let(:user) { create(:user) }
    let(:product) { create(:product) }
    let(:product2) { create(:product) }
    let(:items) do
      create_list(:item, 1, :with_specific_user_and_product, cart_id: user.cart.id, product_id: product.id)
    end
    let(:items2) do
      create_list(:item, 1, :with_specific_user_and_product, cart_id: user.cart.id, product_id: product2.id)
    end
    let(:order) { create(:order, :with_specific_user_and_items, user_id: user.id, items:) }
    let(:order2) { create(:order, :with_specific_user_and_items, user_id: user.id, items:) }
    let(:orders) { [order, order2] }
    before do
      allow(Order).to receive(:where).and_return(orders)
    end

    it 'generates csv data' do
      expect(CSV).to receive(:generate).and_call_original
      DownloadOrdersCsvJob.new.perform(start_date, end_date)
    end

    it 'saves csv data to file' do
      file_path = Rails.root.join('tmp', 'orders.csv')
      expect(File).to receive(:open).with(file_path, 'w')
      DownloadOrdersCsvJob.new.perform(start_date, end_date)
    end
  end
end
