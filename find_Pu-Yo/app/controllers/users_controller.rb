#! http://localhost:3000/users/new
#! input zerodie
#! it will save zerodie's name and uid into user
#! and save zerodie's friends (uid) into friendship
#! ex: user_id = 267660 userB_id = 8045340 
#!     means 267660 has friend 8045340

class UsersController < ApplicationController

  def index
    @user = User.find(1) #zerodie
    @friends = @user.all_friends
    @counter = count(@friends)
    #@user.uid = user_id2uid(@user.name)
    respond_to do |format|
      format.html
    end
  end
  
  def count(friends_l1)
    counter = {}
    counter.default = 0
    friends_l1.each do |f|
      friends_l2 = f.all_friends
      friends_l2.each do |f2|
        counter[f2.nick_name] = counter[f2.nick_name] + 1
      end
    end
    counter
  end
      
end
