FactoryBot.define do
  # Define your Spree extensions Factories within this file to enable applications, and other extensions to use and override them.
  #
  # Example adding this to your spec_helper will load these Factories for use:
  # require 'spree_loyalty_points/factories'
  #
  # Note: Basic Spree factories (address, product, variant, line_item, stock_location, shipment, etc.)
  # are now provided by Spree core (loaded via spec/rails_helper.rb).
  # We only define loyalty points specific factories here.

  # Loyalty Points payment method factory
  factory :loyalty_points_payment_method, parent: :payment_method, class: Spree::PaymentMethod::LoyaltyPoints do
    type { 'Spree::PaymentMethod::LoyaltyPoints' }
    name { 'Loyalty Points' }
    active { true }
  end

  factory :loyalty_points_transaction, class: Spree::LoyaltyPointsTransaction do
    loyalty_points { (10..99).to_a.sample }
    balance { (100..999).to_a.sample }
    comment { "loyalty points test comment" }
    type { "Spree::LoyaltyPointsCreditTransaction" }

    association :user, factory: :user_with_loyalty_points
    # source is optional - add it in tests that need it with `association :source, factory: :order`

    factory :loyalty_points_credit_transaction, class: Spree::LoyaltyPointsCreditTransaction do
      type { "Spree::LoyaltyPointsCreditTransaction" }
    end

    factory :loyalty_points_debit_transaction, class: Spree::LoyaltyPointsDebitTransaction do
      type { "Spree::LoyaltyPointsDebitTransaction" }
    end
  end

  factory :user_with_loyalty_points, parent: :user do
    loyalty_points_balance { (100..999).to_a.sample }

    transient do
      transactions_count { 0 }
    end

    after(:create) do |user, evaluator|
      if evaluator.transactions_count > 0
        order = create(:order, user: user)
        create_list(:loyalty_points_transaction, evaluator.transactions_count, user: user, source: order)
      end
    end
  end

  factory :order_with_loyalty_points, parent: :order do
    association :user, factory: :user_with_loyalty_points

    transient do
      transactions_count { 5 }
    end

    after(:create) do |order, evaluator|
      create_list(:loyalty_points_transaction, evaluator.transactions_count, user: order.user, source: order)
    end
  end

  # Shipped order with loyalty points (for return authorization tests)
  factory :shipped_order_with_loyalty_points, parent: :shipped_order do
    association :user, factory: :user_with_loyalty_points
    association :bill_address, factory: :address
    association :ship_address, factory: :address

    transient do
      transactions_count { 5 }
      with_payment { false }  # Disable auto-payment creation to avoid source validation issues
    end

    after(:create) do |order, evaluator|
      create_list(:loyalty_points_transaction, evaluator.transactions_count, user: order.user, source: order)
    end
  end

  factory :payment_with_loyalty_points, parent: :payment do
    association :order, factory: :order_with_loyalty_points

    # Use transient to allow payment_method override from tests
    transient do
      custom_payment_method { nil }
    end

    payment_method { custom_payment_method || create(:loyalty_points_payment_method, stores: [order.store]) }
  end

  factory :return_authorization_with_loyalty_points, parent: :return_authorization do
    loyalty_points { (50..99).to_a.sample }
    loyalty_points_transaction_type { "Debit" }

    association :order, factory: :shipped_order_with_loyalty_points
    association :stock_location, factory: :stock_location
    association :reason, factory: :return_authorization_reason
  end
end
