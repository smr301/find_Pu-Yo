#ruby crawler.rb then start crawl.

#!/usr/bin/env ruby
#require File.dirname(__FILE__) + '/config/environments/development.rb'
#File.dirname(__FILE__) is the position right now.
require ::File.expand_path('../config/environment', __FILE__)

require 'rubygems'
require 'net/http'
require 'json'

GET_FRIENDS_URL="http://www.plurk.com/API/FriendsFans/getFriendsByOffset?api_key=YQ5SyniL23c9lAvyeZc2WGbcT5FCgPvk&user_id="
GET_PROFILE_URL="http://www.plurk.com/API/Profile/getPublicProfile?api_key=YQ5SyniL23c9lAvyeZc2WGbcT5FCgPvk&user_id="

@count = 1
@nfriends = 0
    
def set_user_data(user_id) #can use nick_name or uid

  public_profile_url = GET_PROFILE_URL + user_id.to_s
  uri = URI.parse(public_profile_url)
  res = Net::HTTP.get_response uri
  data = res.body
  public_profile = JSON.parse(data)
  #user = User.create(public_profile["user_info"]) 
  #in `block in attributes=': unknown attribute: relationship (ActiveRecord::UnknownAttributeError)
  user = User.new
  @nfriends = public_profile["friends_count"]
  user.uid = public_profile["user_info"]["uid"]
  user.gender = public_profile["user_info"]["gender"]
  user.display_name = public_profile["user_info"]["display_name"]
  user.nick_name = public_profile["user_info"]["nick_name"]
  user.has_profile_image = public_profile["user_info"]["has_profile_image"]
  user.avatar = public_profile["user_info"]["avatar"]
  user.save 
  user
end

def get_friends_by_offset(uid, offset)
  friends_url = GET_FRIENDS_URL + uid.to_s + "&offset=" + offset.to_s + "&limit=50"
  uri = URI.parse(friends_url)
  res = Net::HTTP.get_response uri
  data = res.body
  friends_list = JSON.parse(data)
end

def get_friends(uid)

  offset = 0
  friends = []
  friends_tmp = get_friends_by_offset(uid, offset)
  friends += friends_tmp
  while (friends_tmp!=[]&&offset<=1000) do    
    friends_tmp = get_friends_by_offset(uid, offset)
    friends += friends_tmp
    offset += 50
    print "-----offset:#{offset}-----\n"
  end
  friends
end

def add_friends_to_database(user)
  friends_list = get_friends(user.uid)
  friends_list.each do |f|
  
    u = User.find_or_create_by_uid(f["uid"])
    check = Friendship.find_by_user_id_and_friend_id(u.id, user.id)
    #check = u.inverse_friendships.find_by_user_id(u.id)
    next if check != nil
    #if check == nil
      print "************\n"
      u.gender = f["gender"]
      u.display_name = f["display_name"]
      u.nick_name = f["nick_name"]
      u.has_profile_image = f["has_profile_image"]
      u.avatar = f["avatar"]
      u.save
    
      #friendship = user.friendships.new 
      friendship = Friendship.new
      friendship.friend = u
      friendship.user = user
      friendship.save
  
      print "crawled #{@count} users....\n"
      @count += 1
    #else
      #print "%%%%%%%%%%%%%%%%%%\n"
      #print "check uid=#{check.user_id},check fid=#{check.friend_id},user id=#{user.id}, u id=#{u.id}\n"
    #end
    
  end
end

loop do
  @user = User.find_by_crawled(nil)
  if @user == nil
    @user = set_user_data("zerodie")
  end
  print "-----user:#{@user.nick_name}-----\n"
  add_friends_to_database(@user)
  @user.update_attribute("crawled",1)
  print "-----finish crawling one user's friends -----\n"
  print "-----#frienships:#{Friendship.all.count}, #users:#{User.all.count}-----\n\n"
end
