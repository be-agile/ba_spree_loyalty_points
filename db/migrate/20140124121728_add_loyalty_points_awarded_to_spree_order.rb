class AddLoyaltyPointsAwardedToSpreeOrder < ActiveRecord::Migration[8.0]
  def change
    add_column :spree_orders, :loyalty_points_awarded, :boolean, default: false, null: false
  end
end
