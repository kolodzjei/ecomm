# frozen_string_literal: true

require 'rails_helper'
RSpec.describe CancelUnpaidOrderJob, type: :job do
  let(:user) { create(:user) }
  let(:product) { create(:product) }
  let(:items) { create_list(:item, 1, :with_specific_user_and_product, cart_id: user.cart.id, product_id: product.id) }
  let(:order) { create(:order, :with_specific_user_and_items, user_id: user.id, items:) }

  describe '#perform' do
    context 'when order is paid' do
      before do
        order.pay
        order.save
      end

      it 'does not cancel the order' do
        expect { described_class.new.perform(order.id) }.not_to(change { order.reload.status })
      end
    end

    context 'when order is unpaid' do
      it 'cancels the order' do
        expect { described_class.new.perform(order.id) }.to change {
                                                              order.reload.status
                                                            }.from('pending').to('cancelled')
      end
    end
  end
end
