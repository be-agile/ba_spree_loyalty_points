module SpreeLoyaltyPoints
  module CheckoutControllerDecorator
    def self.prepended(base)
      base.before_action :sufficient_loyalty_points, only: [:update], if: -> { params[:state] == 'payment' }
    end

    private

    def sufficient_loyalty_points
      payment_method_ids = params[:order][:payments_attributes].collect do |payment|
        payment["payment_method_id"]
      end
      if Spree::PaymentMethod.loyalty_points_id_included?(payment_method_ids) && !@order.user.has_sufficient_loyalty_points?(@order)
        flash[:error] = Spree.t(:insufficient_loyalty_points)
        redirect_to Spree::Core::Engine.routes.url_helpers.checkout_state_path(@order.token, @order.state)
      end
    end
  end
end

if Spree::CheckoutController.included_modules.exclude?(SpreeLoyaltyPoints::CheckoutControllerDecorator)
  Spree::CheckoutController.prepend SpreeLoyaltyPoints::CheckoutControllerDecorator
end
