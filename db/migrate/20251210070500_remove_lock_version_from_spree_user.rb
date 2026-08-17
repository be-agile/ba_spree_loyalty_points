class RemoveLockVersionFromSpreeUser < ActiveRecord::Migration[8.0]
  def change
    # Remove lock_version column that was added by 20140207055836_add_lock_version_to_spree_user.rb
    # This column is not actually used by the loyalty points engine and causes
    # ActiveRecord::StaleObjectError when User is touched by related models
    users_table_name = Spree.user_class.present? ? Spree.user_class.table_name : :spree_users
    if table_exists?(users_table_name) && column_exists?(users_table_name, :lock_version)
      remove_column users_table_name, :lock_version, :integer, default: 0, null: false
    end
  end
end
