class PagesController < ApplicationController
  def home
   @title = "Home"
   if signed_in?
     @micropost = Micropost.new
     @feed_items = current_user.feed.paginate(:page => params[:page])
   end
  end

  def menu
   @title = "Set menu"
   if signed_in?
     @menu = Menu.new
     @delivery = Delivery.new
     usermenus = current_user.menus
     @menus = usermenus.paginate(:page => params[:page])
     @deliveries = Array.new([])
     unless usermenus.empty?
       usermenus.each do |usermenuitem|
         @deliveries.push(usermenuitem.deliveries)
       end
     end  
   else
     redirect_to signin_path
   end
  end

  def working
   @title = "Working"
   if signed_in?
     @account = Account.new(:employer_id => current_user.id)
     @accounts = current_user.working.paginate(:page => params[:page])
     @owners = current_user.owners
   else
     redirect_to signin_path
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
