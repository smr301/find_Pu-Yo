#! http://localhost:3000/users/new
#! input zerodie
#! it will save zerodie's name and uid into user
#! and save zerodie's friends (uid) into friendship
#! ex: user_id = 267660 userB_id = 8045340 
#!     means 267660 has friend 8045340

class UsersController < ApplicationController

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
  
    @user = User.new
   
    respond_to do |format|
      format.html
      #fomat.xml { render :xml => @user }
    end
  end

  

end
