class Admin::UsersController < ApplicationController
  include Authorization

  before_action :require_admin
  before_action :set_user, only: %i[ update destroy ]

  def index
    @users = User.order(:email_address)
  end

  def update
    if @user == Current.user && params[:user][:role] != "admin"
      redirect_to admin_users_path, alert: "You can't remove your own admin access."
      return
    end

    if @user.update(role: params[:user][:role])
      redirect_to admin_users_path, notice: "Updated #{@user.email_address}."
    else
      redirect_to admin_users_path, alert: "Could not update #{@user.email_address}."
    end
  end

  def destroy
    if @user == Current.user
      redirect_to admin_users_path, alert: "You can't delete your own account."
    else
      @user.destroy
      redirect_to admin_users_path, notice: "Deleted #{@user.email_address}."
    end
  end

  private
    def set_user
      @user = User.find(params[:id])
    end
end
