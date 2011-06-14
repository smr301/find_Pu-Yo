class FriendsController < ApplicationController
  
  def test
    @user = User.new
  end

  def index
    #@user = User.find_by_nick_name("zerodie")
    @user = User.find_by_nick_name(params[:user_name])
    friends = @user.all_friends
    @counter = count(friends)[0..9] #top10 recommended
    respond_to do |format|
      format.html
    end
  end

  def count(friends_l1)
    counter = {} #record friends_not_yet
    counter.default = 0
    counter2 = {} #record friends_already
    friends_l1.each do |f|
      counter2[f.nick_name] = 0
    end

    friends_l1.each do |f|
      friends_l2 = f.all_friends
      friends_l2.each do |f2|
        if counter2.has_key?(f2.nick_name)
          counter2[f2.nick_name] = counter2[f2.nick_name] + 1 
        else
          counter[f2.nick_name] = counter[f2.nick_name] + 1 
        end
      end
    end
    counter[@user.nick_name] = -1 #self=-1 for flag
    @counter2 = counter2.sort { |a,b| b[1]<=>a[1] } [0..9]#sort by value and access top10
    counter.sort { |a,b| b[1]<=>a[1] } #sort by value    
  end
end