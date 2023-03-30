# frozen_string_literal: true

require 'rails_helper'
RSpec.describe OrdersConfirmationJob, type: :job do
  describe '#perform' do
    let(:user) { create(:user) }
    let(:product) { create(:product) }
    let(:items) do
      create_list(:item, 1, :with_specific_user_and_product, cart_id: user.cart.id, product_id: product.id)
    end
    let(:order) { create(:order, :with_specific_user_and_items, user_id: user.id, items:) }

    it 'sends an order confirmation email' do
      expect { described_class.new.perform(order.id) }.to change { ActionMailer::Base.deliveries.count }.by(1)

      mail = ActionMailer::Base.deliveries.last
      expect(mail.to).to eq([order.user.email])
      expect(mail.subject).to include('Order Confirmation')
    end

    it 'does nothing if the order does not exist' do
      expect { described_class.new.perform(-1) }.not_to change { ActionMailer::Base.deliveries.count }
    end
  end
end
