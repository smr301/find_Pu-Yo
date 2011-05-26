class AddUserToFriendship < ActiveRecord::Migration
  def self.up
    add_column :friendships, :user_id, :integer
    add_column :friendships, :friend_id, :integer
  end

  def self.down
    remove_column :friendships, :user_id
    remove_column :friendships, :friend_id
  end
end
