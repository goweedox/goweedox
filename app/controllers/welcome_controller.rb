class WelcomeController < ApplicationController
	  # GET /users/new
  # GET /users/new.xml
  def signup
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @user }
    end
  end

  def login
    if session[:user_id] 
	    redirect_to(:controller => "admin", :action => "index")
    end  
     if request.post?
       user = User.authenticate(params[:name], params[:password])   
       if user &&  (user.name == 'edsonpaul' || user.name =='rj' || user.name =='wella' || user.name =='elodez'|| user.name =='jose' || user.name =='harmy')
         session[:user_id] = user.id
         redirect_to(:controller => 'admin', :action => "index")
       elsif user
	       session[:user_id] = user.id
         redirect_to(:controller => "limited", :action => "index")
       else
         flash.now[:notice] = "Invalid user/password combination!"
       end
     end
  end
  
  def index
	  if session[:user_id] 
	    redirect_to(:controller => "admin", :action => "index")
	  end
  end
end
