class AddUserToFriendship < ActiveRecord::Migration
  def self.up
    add_column :friendships, :userA_id, :integer
    add_column :friendships, :userB_id, :integer
  end

  def self.down
    remove_column :friendships, :userA_id
    remove_column :friendships, :userB_id
  end
end
