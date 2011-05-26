class User < ActiveRecord::Base
  has_many :friendships
  has_many :inverse_friendships, :class_name => 'Friendship', :foreign_key => "friend_id"
  has_many :inverse_friends, :through => :inverse_friendships, :source => :user
  has_many :friends, :through => :friendships
  validates_uniqueness_of :uid
  
  def all_friends
    self.friends + self.inverse_friends
  end
end
