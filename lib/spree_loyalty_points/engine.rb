module SpreeLoyaltyPoints
  class Engine < Rails::Engine
    require 'spree/core'
    isolate_namespace Spree
    engine_name 'spree_loyalty_points'

    config.autoload_paths += %W(#{config.root}/lib)

    # use rspec for tests
    config.generators do |g|
      g.test_framework :rspec
    end

    def self.activate
      Dir.glob(File.join(File.dirname(__FILE__), '../../app/**/*_decorator*.rb')) do |c|
        Rails.configuration.cache_classes ? require(c) : load(c)
      end
      Rails.application.config.paths["app/views"].unshift([Spree::Storefront::Engine.root, 'app/views/themes/default'].join('/'))

      Spree.user_class.class_eval do
        validates :loyalty_points_balance, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

        with_options foreign_key: :user_id do
          has_many :loyalty_points_transactions, class_name: 'Spree::LoyaltyPointsTransaction'
          has_many :loyalty_points_debit_transactions, class_name: 'Spree::LoyaltyPointsDebitTransaction'
          has_many :loyalty_points_credit_transactions, class_name: 'Spree::LoyaltyPointsCreditTransaction'
        end

        def loyalty_points_balance_sufficient?
          loyalty_points_balance >= Spree::Store.default.preferred_loyalty_points_redeeming_balance
        end

        def has_sufficient_loyalty_points?(order)
          loyalty_points_equivalent_currency >= order.total
        end

        def loyalty_points_equivalent_currency
          loyalty_points_balance * Spree::Store.default.preferred_loyalty_points_conversion_rate
        end

      end
    end

    initializer 'spree_loyalty_points.autoloader' do |app|
      if Rails.autoloaders.zeitwerk_enabled?
        Rails.autoloaders.main.ignore("#{root}/app/overrides")
      end
    end

    config.after_initialize do
      Rails.application.config.spree.payment_methods << Spree::PaymentMethod::LoyaltyPoints
    end

    config.to_prepare &method(:activate).to_proc
  end
end
