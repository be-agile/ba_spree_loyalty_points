module Spree
  class LoyaltyPointsTransaction < ActiveRecord::Base
    include Spree::TransactionsTotalValidation
    TRANSACTION_TYPES = ['Spree::LoyaltyPointsCreditTransaction', 'Spree::LoyaltyPointsDebitTransaction']
    CLASS_TO_TRANSACTION_TYPE = { 'Spree::LoyaltyPointsCreditTransaction' => 'Credit', 'Spree::LoyaltyPointsDebitTransaction' => 'Debit'}
    belongs_to :user, class_name: "::#{Spree.user_class}"
    belongs_to :source, polymorphic: true, optional: true

    validates :loyalty_points, numericality: { only_integer: true, message: Spree.t('validation.must_be_int'), greater_than: 0 }
    validates :type, inclusion: { in: TRANSACTION_TYPES }
    validates :balance, presence: true
    validate :source_or_comment_present
    validate :transactions_total_range, if: -> { source.present? && source.loyalty_points_transactions.present? }

    scope :for_order, ->(order) { where(source: order) }

    before_create :generate_transaction_id

    # Spree 5.2(Ransack 4.x)は検索・ソート対象を明示的に allowlist することを要求する。
    # ActiveRecord::Base 継承で Spree::Core::Ransackable を含まないため、Ransack 標準の
    # ransackable_attributes / ransackable_associations をオーバーライドして許可する。
    def self.ransackable_attributes(_auth_object = nil)
      %w[id loyalty_points type user_id source_id source_type balance comment transaction_id created_at updated_at]
    end

    def self.ransackable_associations(_auth_object = nil)
      %w[user source]
    end

    def transaction_type
      CLASS_TO_TRANSACTION_TYPE[type]
    end

    private

      def source_or_comment_present
        unless source.present? || comment.present?
          errors.add :base, 'Source or Comment should be present'
        end
      end

      def generate_transaction_id
        begin
          self.transaction_id = (Time.current.strftime("%s") + rand(999999).to_s).to(15)
        end while Spree::LoyaltyPointsTransaction.where(transaction_id: transaction_id).present?
      end

      def transactions_total_range
        validate_transactions_total_range(transaction_type, source)
      end

  end
end
