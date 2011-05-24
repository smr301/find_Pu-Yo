class AddDataToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :display_name, :string
    add_column :users, :nick_name, :string
    add_column :users, :uid, :integer
    add_column :users, :gender, :integer
    add_column :users, :crawled, :integer
    add_column :users, :has_profile_image, :integer
    add_column :users, :avatar, :integer    
  end

  def self.down
    remove_column :users, :display_name
    remove_column :users, :nick_name
    remove_column :users, :uid
    remove_column :users, :gender
    remove_column :users, :crawled
    remove_column :users, :has_profile_image
    remove_column :users, :avatar
  end
end
