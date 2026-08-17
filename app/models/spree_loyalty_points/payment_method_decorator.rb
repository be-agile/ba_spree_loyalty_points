module SpreeLoyaltyPoints
  module PaymentMethodDecorator
    def self.prepended(base)
      base.scope :loyalty_points_type, -> { where(type: 'Spree::PaymentMethod::LoyaltyPoints') }
      base.extend ClassMethods
    end

    module ClassMethods
      def loyalty_points_id_included?(method_ids)
        loyalty_points_type.where(id: method_ids).size != 0
      end
    end
  end
end

Spree::PaymentMethod.prepend(SpreeLoyaltyPoints::PaymentMethodDecorator)
