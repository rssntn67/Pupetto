class MenusController < ApplicationController
  before_filter :authenticate
  before_filter :authorized_user, :only => :destroy

  def create
    @menu  = current_user.menus.build(params[:menu])
    if @menu.save
      flash[:success] = "Menu created!"
    else
      flash[:error] = "Menu not created!"
    end
      redirect_to '/menu'
  end

  def destroy
    @menu.destroy
    redirect_back_or root_path
  end

private

    def authorized_user
      @menu = current_user.menus.find_by_id(params[:id])
      redirect_to root_path if @menu.nil?
    end
end
