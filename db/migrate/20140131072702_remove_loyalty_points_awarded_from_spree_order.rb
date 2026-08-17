class RemoveLoyaltyPointsAwardedFromSpreeOrder < ActiveRecord::Migration[8.0]
  def change
    remove_column :spree_orders, :loyalty_points_awarded, :boolean, default: false, null: false
  end
end
