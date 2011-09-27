class MenusController < ApplicationController
  before_filter :authenticate
  before_filter :authorized_user, :only => [:destroy, :update]

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
    redirect_to '/menu'
  end

  def edit
    @title = "Edit menu"
    @menu = Menu.find(params[:id])
  end

  def update
      if @menu.update_attributes(params[:menu])
        flash[:success] = "Menu updated."
        redirect_to '/menu'
      else
        @title = "Edit menu"
        flash[:error] = "Menu not updated!"
        render 'edit'
      end
  end

private

    def authorized_user
      @menu = current_user.menus.find_by_id(params[:id])
      redirect_to root_path if @menu.nil?
    end
end
