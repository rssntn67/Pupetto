class OrdersController < ApplicationController
  before_filter :authenticate
  before_filter :authorized_user
  
  respond_to :html, :js

  def increase
      if (@order.nil?)
          @order = current_user.orders.build(params[:order])
          @order.count = 1
          @order.save
      else
          @order.update_attributes(:count => @order.count + 1)
      end
      respond_with(@order, :location => order_account_path(@account))
  end

  def decrease
      unless (@order.nil?)
        if (@order.count == 1 )
            @order.destroy
            @order = current_user.orders.build(params[:order])
            @order.count = 0
        else
           @order.update_attributes(:count => @order.count - 1)
        end
      end
      respond_with(@order, :location => order_account_path(@account))
  end

 private

  def authorized_user
     @account = Account.find(params[:id])
     @order = Order.find_by_account_id_and_delivery_id(params[:order][:account_id],params[:order][:delivery_id])
     redirect_to root_path  unless ( current_user.working.include?(@account) )
  end
end
