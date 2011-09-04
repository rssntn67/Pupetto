class PagesController < ApplicationController
  def home
   @title = "Home"
   if signed_in?
     @micropost = Micropost.new
     @feed_items = current_user.feed.paginate(:page => params[:page])
   end
  end

  def menu
   @title = "Menu"
   if signed_in?
     @menu = Menu.new
     @menus = current_user.menus.paginate(:page => params[:page])
   else
     redirect_to root_path
   end
  end

  def contact
   @title = "Contact"
  end

  def about
   @title = "About"
  end

  def help
   @title = "Help"
  end
end
