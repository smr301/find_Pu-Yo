class AddDataToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :name, :string
    add_column :users, :uid, :integer
  end

  def self.down
    remove_column :users, :name
    remove_column :users, :uid
  end
end
