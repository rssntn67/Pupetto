class AccountsController < ApplicationController
  before_filter :authenticate
  before_filter :authorized_user, :only => [ :destroy, :show ]
  before_filter :authorized_employer, :only => [ :create ]

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
  end

  def show
    @title = @account.table
    @orders = @account.orders.paginate(:page => params[:page])
  end

 private
 
  def authorized_user
     @account = Account.find(params[:id])
     redirect_to root_path  unless ( current_user.working.include?(@account) )  
  end

  def authorized_employer
     redirect_to root_path unless (current_user.owners.include?(User.find(params[:account][:owner_id])))
  end
end
