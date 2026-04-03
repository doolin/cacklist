class AddAdminToUsers < ActiveRecord::Migration[8.1]
  def self.up
    add_column :users, :admin, :boolean, default: false
  end

  def self.down
    remove_column :users, :admin
  end
end
