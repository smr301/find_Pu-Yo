
class FriendsController < ApplicationController
  include FriendsHelper  
  def query
  end

  def index
    #@user = User.find_by_nick_name("zerodie")
    @gender = params[:gender].to_i
    @user = User.find_by_nick_name(params[:user_name])
    if @user != nil && @user.crawled==1 #"level2 not crawled" r not handled yet
      friends = @user.all_friends
      #grab_level_2(friends)
      @counter = count(friends)[0..9] #top10 recommended
    else
      redirect_to :action => :nothisuser
    end
    
  end

  def grab_level_2(friends)
    friends.each do |f|
      if f.crawled != 1
        puts get_friends_by_offset(f.uid, 0)
        add_friends_to_database(f)
        f.update_attribute("crawled",1)
        print f.id
        print "grab new one user\n"
      end
    end
  end
  
  
  def count(friends_l1)
    counter = {} #record friends_not_yet
    counter.default = 0
    counter2 = {} #record friends_already
    friends_l1.each do |f|
      counter2[f.uid] = 0
    end
    normalizer = {}
    normalizer.default = 0
    
    friends_l1.each do |f|
      friends_l2 = f.all_friends
      normalizer[f.uid] = friends_l2.count
      friends_l2.each do |f2|
        if counter2.has_key?(f2.uid)
          counter2[f2.uid] = counter2[f2.uid] + 1 
        else
          if @gender == 2 #all
              counter[f2.uid] = counter[f2.uid] + 1
          elsif f2.gender == @gender
              counter[f2.uid] = counter[f2.uid] + 1
          end 
        end
      end
    end
    
    #preprocess
    counter[@user.uid] = -1 #self=-1 for flag
    counter[18757] = -1 
    counter2[18757] = -1 #plurkbuddy out
    
    #friends goodness normalize
    counter2.each do | key, value |
      counter2[key] = (10000*value) / normalizer[key]
    end
    
    @counter2 = counter2.sort { |a,b| b[1]<=>a[1] } [0..9]#sort by value and access top10
    counter.sort { |a,b| b[1]<=>a[1] } #sort by value    
  end
  
  def about
  end 
  
  def random
  end
  
  def nothisuser
  end
  
end