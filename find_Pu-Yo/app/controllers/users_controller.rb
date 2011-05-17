require 'rubygems'
require 'net/http'
require 'json'

class UsersController < ApplicationController
  
  
  def show
    @user = User.find(params[:id])
    #@user.uid = user_id2uid(@user.name)
    respond_to do |format|
      format.html
    end
  end
  
  #GET /users/new
  def new
    @user = User.new
    respond_to do |format|
      format.html
      #fomat.xml { render :xml => @user }
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
  
  def user_id2uid(user_id)
    public_profile_url = "http://www.plurk.com/API/Profile/getPublicProfile?api_key=YQ5SyniL23c9lAvyeZc2WGbcT5FCgPvk&user_id=" + user_id
    uri = URI.parse(public_profile_url)
    res = Net::HTTP.get_response uri
    data = res.body
    public_profile = JSON.parse(data)
    uid = public_profile["user_info"]["uid"] 
  end
  
  def get_friends(uid)
    friends_url = "http://www.plurk.com/API/FriendsFans/getFriendsByOffset?api_key=YQ5SyniL23c9lAvyeZc2WGbcT5FCgPvk&user_id=" + uid.to_s + "&limit=500"
    uri = URI.parse(friends_url)
    res = Net::HTTP.get_response uri
    data = res.body
    friends_list = JSON.parse(data)
  end
  
  def add_friends_to_database(user)
    friends_list = get_friends(user.uid)
    friends_list.each do |f|
      friendship = Friendship.new
      friendship.userA_id = user.uid
      friendship.userB_id = f["uid"]
      friendship.save
    end
  end
end
