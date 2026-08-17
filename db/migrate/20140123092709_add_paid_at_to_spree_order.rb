class AddPaidAtToSpreeOrder < ActiveRecord::Migration[8.0]
  def change
    add_column :spree_orders, :paid_at, :datetime
  end
end
