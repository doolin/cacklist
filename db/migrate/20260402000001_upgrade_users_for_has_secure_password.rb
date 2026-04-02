class UpgradeUsersForHasSecurePassword < ActiveRecord::Migration[7.1]
  def change
    rename_column :users, :encrypted_password, :password_digest
    remove_column :users, :salt, :string
    add_column :users, :remember_digest, :string
    add_index :microposts, :user_id
    add_index :relationships, :follower_id
    add_index :relationships, :followed_id
    add_index :relationships, [:follower_id, :followed_id], unique: true
  end
end
