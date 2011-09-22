class AccountsController < ApplicationController
  def show
    if signed_in? 
      @account = Account.find(params[:id])
      @title = @account.table
      @orders = @account.orders.paginate(:page => params[:page])
      account_user(@account) 
    else
      redirect_to signin_path
    end
  end

 private
 
  def account_user(account)
     redirect_to(root_path) unless ( current_user.working.include?(account) )  
  end

end
