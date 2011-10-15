class AccountsController < ApplicationController
  before_filter :authenticate
  before_filter :authorized_user, :only => [ :show, :update, :order ]
  before_filter :authorized_employer, :only => [ :create ]
  before_filter :is_owner, :only => [ :destroy ]

  def order
    @title = "Order " + @account.table
    usermenus = @account.owner.menus
    @menus = usermenus.paginate(:page => params[:page])
    @deliveries = Array.new([])
    unless usermenus.empty?
      usermenus.each do |usermenuitem|
        orders = Array.new([])
        usermenuitem.deliveries.each do |delivery|
           order = Order.find_by_account_id_and_delivery_id(@account.id, delivery.id )
           if order.nil?
              order = current_user.orders.build(:delivery_id => delivery.id, :account_id => @account.id, :count => 0)
           end
           orders.push(order)
        end
        @deliveries.push(orders)
      end
    end
    render 'order'
  end

  def update
    if @account.update_attributes(params[:account])
      flash[:success] = "Account updated."
      @title = @account.table
      @orders = @account.orders.paginate(:page => params[:page])
      @total = calculate_total
      render 'show'
    else
      @title = "Edit account"
      flash[:error] = "Account not updated!"
      render 'edit'
    end
  end

  def create
    @account  = current_user.accounts.build(params[:account])
    if @account.save
      flash[:success] = "Account created!"
    else
      flash[:error] = "Account not created!"
    end
      redirect_to '/working'
  end

  def destroy
     @account.destroy
     redirect_to '/working'
  end

  def show
    @title = @account.table
    @orders = @account.orders.paginate(:page => params[:page])
    @total = calculate_total
  end

  def edit
    @title = "Edit account"
    @account = Account.find(params[:id])
  end

 private
 
  def authorized_user
     @account = Account.find(params[:id])
     redirect_to root_path  unless ( current_user.working.include?(@account) )  
  end

  def authorized_employer
     redirect_to root_path unless (current_user.owners.include?(User.find(params[:account][:owner_id])))
  end
 
  def is_owner
     @account = Account.find(params[:id])
     redirect_to root_path  unless current_user?(@account.owner)
  end
 
  def calculate_total
      value = 0
      @account.orders.each do |order|
         value = value + order.delivery.price * order.count
      end
      return value
  end
end
