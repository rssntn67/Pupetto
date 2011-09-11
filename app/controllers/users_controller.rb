class UsersController < ApplicationController
  
  before_filter :authenticate, :except => [:show, :new, :create, :show_menu]
  before_filter :correct_user, :only => [:edit, :update]
  before_filter :admin_user,   :only => :destroy

  def following
    show_follow(:following)
  end

  def followers
    show_follow(:followers)
  end

  def crew
    show_follow(:employers)
  end
  
  def show_follow(action)
    @title = action.to_s.capitalize
    @user = User.find(params[:id])
    @users = @user.send(action).paginate(:page => params[:page])
    render 'show_follow'
  end

  def menu()
    @title = "User menu" 
    @user = User.find(params[:id])
    usermenus = @user.menus
    @menus = usermenus.paginate(:page => params[:page])
    @deliveries = Array.new([])
    unless usermenus.empty?
      usermenus.each do |usermenuitem|
        @deliveries.push(usermenuitem.deliveries)
      end
    end
    render 'show_menu'
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User destroyed."
    redirect_to users_path
  end

  def index
    @title = "All users"
    @users = User.paginate(:page => params[:page])
  end

  def update
      if @user.update_attributes(params[:user])
        flash[:success] = "Profile updated."
        redirect_to @user
      else
        @title = "Edit user"
        render 'edit'
      end
  end
 
  def show
      @user = User.find(params[:id])
      @microposts = @user.microposts.paginate(:page => params[:page])
      @title = @user.name
  end

  def edit
      @title = "Edit user"
  end

  def create
      @user = User.new(params[:user])
      if @user.save
	sign_in @user
        flash[:success] = "Welcome to the Pupetto App!"
        redirect_to @user
      else
        @title = "Sign up"
        render 'new'
      end
  end 

  def new
    @user = User.new
    @title = "Sign up"
  end

  private

      def correct_user
        @user = User.find(params[:id])
        redirect_to(root_path) unless current_user?(@user)
      end
    
      def admin_user
        redirect_to(root_path) unless current_user.admin?
      end
end
