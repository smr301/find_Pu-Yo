class FriendshipsController < ApplicationController
  
  #GET /friendships/new
  def new
    @friendship = Friendship.new
    respond_to do |format|
      format.html
      #fomat.xml { render :xml => @friendship }
    end
  end
  
  #POST /friendships
  def create
    @friendship = Friendship.new(params[:friendship])
    respond_to do |format|
      if @friendship.save
        format.html
      else
        format.html { render :action => "new" }
      end
    end
  end
  
end
