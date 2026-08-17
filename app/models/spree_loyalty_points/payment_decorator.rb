module SpreeLoyaltyPoints
  module PaymentDecorator
    def self.prepended(base)
      base.include Spree::LoyaltyPoints
      base.include Spree::Payment::LoyaltyPoints

      base.validates :amount, numericality: { greater_than: 0 }, if: :by_loyalty_points?
      base.validate :redeemable_user_balance, if: :by_loyalty_points?
      base.scope :state_not, ->(s) { where('state != ?', s) }

      fsm = base.state_machines[:state]
      fsm.after_transition from: fsm.states.map(&:name) - [:completed], to: [:completed], do: :notify_paid_order
      fsm.after_transition from: fsm.states.map(&:name) - [:completed], to: [:completed], do: :redeem_loyalty_points, if: :by_loyalty_points?
      fsm.after_transition from: [:completed], to: fsm.states.map(&:name) - [:completed], do: :return_loyalty_points, if: :by_loyalty_points?
    end

    private

    # @gem-override spree_core-5.3.6/app/models/spree/payment.rb#invalidate_old_payments
    # @see https://github.com/be-agile/giga-repeat/commit/7c6b01c098e0003527926b1c221d4a586fe76a23
    # ロイヤリティポイント決済を無効化対象から除外する。
    def invalidate_old_payments
      return if store_credit? || by_loyalty_points?
      order.payments.with_state('checkout').where("id != ?", self.id).each do |payment|
        payment.invalidate! unless payment.store_credit?
      end
    end

    def notify_paid_order
      if all_payments_completed?
        order.touch :paid_at
      end
    end

    def all_payments_completed?
      order.payments.state_not('invalid').all? { |payment| payment.completed? }
    end
  end
end

Spree::Payment.prepend SpreeLoyaltyPoints::PaymentDecorator
