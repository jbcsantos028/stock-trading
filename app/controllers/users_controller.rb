class UsersController < ApplicationController
  before_action :only_admin, only: :adminpanel

  def adminpanel
    @users = User.all
  end

  # GET /users/new
  def new
    if current_user.admin?
      @user = User.new
    end
  end

  # POST /users
  def create
    @user = User.new(user_params)

    if @user.save
        redirect_to adminpanel_path
    else
        render :new
    end
end

  

  private

  def only_admin
    if current_user.nil? || current_user.admin == false
      redirect_to root_path
    end
  end

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
