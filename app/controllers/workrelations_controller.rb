class WorkrelationsController < ApplicationController
  before_filter :authenticate

  respond_to :html, :js
  def create
    @user = User.find(params[:workrelation][:employer_id])
    current_user.employ!(@user)
    respond_with @user
  end

  def destroy
    @user = Workrelation.find(params[:id]).employer
    current_user.unemploy!(@user)
    respond_with @user
  end
end
