class DeliveriesController < ApplicationController
  before_filter :authenticate
  before_filter :authorized_user, :only => [:destroy, :update]

  def edit
    @title = "Edit menu voice"
    @delivery = Delivery.find(params[:id])
  end

  def create
    @del =   Menu.find(params[:delivery][:menu_id]).deliveries.build(params[:delivery])
    if @del.save
      flash[:success] = "delivery created!"
    else
      flash[:error] = "delivery not created!"
    end
      redirect_to '/menu'
  end

  def update
    if @delivery.update_attributes(params[:delivery])
        flash[:success] = "delivery updated."
        redirect_to '/menu'
    else
        @title = "Edit menu voice"
        render 'edit'
    end
  end

  def destroy
    @delivery.destroy
    redirect_to '/menu'
  end
  
  private
    def authorized_user
      @delivery = Delivery.find(params[:id])
      redirect_to root_path if @delivery.nil?
      @menu = current_user.menus.find_by_id(@delivery.menu_id)
      redirect_to root_path if @menu.nil?
    end
end
