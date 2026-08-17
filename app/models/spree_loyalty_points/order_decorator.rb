module SpreeLoyaltyPoints
  module OrderDecorator
    def self.prepended(base)
      base.include Spree::LoyaltyPoints
      base.include Spree::Order::LoyaltyPoints

      base.has_many :loyalty_points_transactions, as: :source
      base.has_many :loyalty_points_credit_transactions, as: :source
      base.has_many :loyalty_points_debit_transactions, as: :source

      base.scope :loyalty_points_not_awarded, -> {
        includes(:loyalty_points_credit_transactions).where(spree_loyalty_points_transactions: { source_id: nil })
      }

      base.scope :with_hours_since_payment, ->(num) {
        where('`spree_orders`.`paid_at` < ? ', num.hours.ago)
      }

      base.scope :with_uncredited_loyalty_points, ->(num) {
        with_hours_since_payment(num).loyalty_points_not_awarded
      }

      # FSM transitions
      base.state_machines[:state].after_transition(
        from: base.state_machines[:state].states.map(&:name) - [:complete],
        to: [:complete],
        do: :complete_loyalty_points_payments
      )
    end
  end
end

Spree::Order.prepend(SpreeLoyaltyPoints::OrderDecorator)
