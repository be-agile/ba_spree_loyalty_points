class AddLoyaltyPointsBalanceToSpreeUser < ActiveRecord::Migration[8.0]
  def change
    users_table_name = Spree.user_class.present? ? Spree.user_class.table_name : :spree_users
    add_column users_table_name, :loyalty_points_balance, :integer, default: 0, null: false
  end
end
