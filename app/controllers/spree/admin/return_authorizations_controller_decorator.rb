module Spree
  module Admin
    module ReturnAuthorizationsControllerDecorator
      def self.prepended(base)
        base.before_action :set_loyalty_points_transactions, only: [:new, :edit, :create, :update]
      end

      private

      def set_loyalty_points_transactions
        # new アクションでは @return_authorization がまだ build されておらず、
        # 親注文の instance var もこの before_action 時点では未設定
        # (Spree 5.3.6 の load_resource は member_action 以外で resource を組み立てない)。
        # ネストルートの :order_id (注文番号) から注文を解決してフォールバックする (#1253)。
        order = @return_authorization&.order ||
                (params[:order_id].present? && Spree::Order.find_by(number: params[:order_id]))
        return if order.blank?

        @loyalty_points_transactions = order.loyalty_points_transactions.
          page(params[:page]).
          per(params[:per_page] || 25)
      end
    end
  end
end

Spree::Admin::ReturnAuthorizationsController.prepend(Spree::Admin::ReturnAuthorizationsControllerDecorator)