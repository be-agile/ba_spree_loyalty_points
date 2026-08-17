module SpreeLoyaltyPoints
  module StoreDecorator
    def self.prepended(base)
      base.preference :loyalty_points_awarding_unit, :decimal, default: 0.01
      base.preference :loyalty_points_redeeming_balance, :decimal, default: 0.0
      base.preference :loyalty_points_conversion_rate, :decimal, default: 1.0
      base.preference :loyalty_points_award_period, :integer, default: 12
      base.preference :min_amount_required_to_get_loyalty_points, :decimal, default: 0.0
    end
  end
end

Spree::Store.prepend SpreeLoyaltyPoints::StoreDecorator
