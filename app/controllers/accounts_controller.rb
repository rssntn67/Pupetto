class AccountsController < ApplicationController
  before_filter :authenticate
  before_filter :authorized_user, :only => [ :destroy, :show, :update ]
  before_filter :authorized_employer, :only => [ :create ]

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
 
  def calculate_total
      value = 0
      @account.orders.each do |order|
         value = value + order.delivery.price * order.count
      end
      return value
  end
end
