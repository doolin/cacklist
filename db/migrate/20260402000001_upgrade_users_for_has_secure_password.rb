class UpgradeUsersForHasSecurePassword < ActiveRecord::Migration[8.1]
  def change
    rename_column :users, :encrypted_password, :password_digest
    remove_column :users, :salt, :string
    add_column :users, :remember_digest, :string
    add_index :relationships, %i[follower_id followed_id], unique: true
  end
end
