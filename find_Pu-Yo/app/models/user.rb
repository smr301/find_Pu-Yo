class User < ActiveRecord::Base
  has_many :friendships
  has_many :friends, :through => :friendships
  validates_uniqueness_of :uid
end
