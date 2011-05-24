#! http://localhost:3000/users/new
#! input zerodie
#! it will save zerodie's name and uid into user
#! and save zerodie's friends (uid) into friendship
#! ex: user_id = 267660 userB_id = 8045340 
#!     means 267660 has friend 8045340

require 'rubygems'
require 'net/http'
require 'json'

class UsersController < ApplicationController

  GET_FRIENDS_URL="http://www.plurk.com/API/FriendsFans/getFriendsByOffset?api_key=YQ5SyniL23c9lAvyeZc2WGbcT5FCgPvk&user_id="
  GET_PROFILE_URL="http://www.plurk.com/API/Profile/getPublicProfile?api_key=YQ5SyniL23c9lAvyeZc2WGbcT5FCgPvk&user_id="
  
  def show
    @user = User.find(params[:id])
    #@user.uid = user_id2uid(@user.name)
    respond_to do |format|
      format.html
    end
  end

  
  #POST /users
  def create
    @user = User.new(params[:user])
    
    respond_to do |format|
      @user.uid = user_id2uid(@user.name)
      
      if @user.save
        add_friends_to_database(@user)
        format.html { redirect_to(@user, :notice => 'User was successfully created.' ) }
      else
        format.html { render :action => "new" }
      end
    end
  end

  
  def user_id2uid(user_id) #zerodie return =>267660
    public_profile_url = GET_PROFILE_URL + user_id
    uri = URI.parse(public_profile_url)
    res = Net::HTTP.get_response uri
    data = res.body
    public_profile = JSON.parse(data)
    uid = public_profile["user_info"]["uid"] 
  end
      
  #GET /users/new
  def new
  
    #@user = User.new
    #first = "hothero"
    #@user = set_user_data(first)
    
    #@user.save
    #add_friends_to_database(@user)
  
    #@user.update_attribute("crawled",1)
    i=0
    while(i<2)
      @user = User.find_by_crawled(nil)
      if @user == nil
        @user = User.new
        @user = set_user_data("zerodie")
      end
      add_friends_to_database(@user)
      @user.update_attribute("crawled",1)
      
      i+=1
    end  
    respond_to do |format|
      format.html
      #fomat.xml { render :xml => @user }
    end
  end

  
  def test
    "testing"
  end
    
  def set_user_data(user_id) #can use nick_name or uid

    public_profile_url = GET_PROFILE_URL + user_id.to_s
    uri = URI.parse(public_profile_url)
    res = Net::HTTP.get_response uri
    data = res.body
    public_profile = JSON.parse(data)
    user = User.new
    user.uid = public_profile["user_info"]["uid"]
    user.gender = public_profile["user_info"]["gender"]
    user.display_name = public_profile["user_info"]["display_name"]
    user.nick_name = public_profile["user_info"]["nick_name"]
    user.has_profile_image = public_profile["user_info"]["has_profile_image"]
    user.avatar = public_profile["user_info"]["avatar"]
    #user.save 
    user  
  end
  
  def get_friends(uid)
    friends_url = GET_FRIENDS_URL + uid.to_s + "&limit=500"
    uri = URI.parse(friends_url)
    res = Net::HTTP.get_response uri
    data = res.body
    friends_list = JSON.parse(data)
  end
  
  def add_friends_to_database(user)
    friends_list = get_friends(user.uid)
    friends_list.each do |f|
      friendship = Friendship.new
      friendship.userB_id = f["uid"]
      friendship.user = user
      friendship.save
      friend = User.new
      friend = set_user_data(f["uid"])
      friend.save
    end
  end
end
