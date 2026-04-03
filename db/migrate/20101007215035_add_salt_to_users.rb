class AddSaltToUsers < ActiveRecord::Migration[8.1]
  def self.up
    add_column :users, :salt, :string
  end

  def self.down
    remove_column :users, :salt
  end
end
