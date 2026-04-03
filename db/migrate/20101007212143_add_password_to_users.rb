class AddPasswordToUsers < ActiveRecord::Migration[8.1]
  def self.up
    add_column :users, :encrypted_password, :string
  end

  def self.down
    remove_column :users, :encrypted_password
  end
end
