class UsersController < ApplicationController
  before_action :only_admin, only: :adminpanel

  def adminpanel
    @users = User.where(admin: false)
  end

  def approve
    @users = User.where(admin: false, approved: false)
  end

  def index
    if current_user.admin?
      @users = User.where(admin: false)
    end
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

  # GET /users/:id
  def show
    @user = User.find(params[:id])
  end

  # GET /users/:id/edit
  def edit
    if current_user.admin?
      @user = User.find(params[:id])
    end
  end

  # PATCH /users/:id
  def update
    @user = User.find(params[:id])

    if @user.update(user_params)
      redirect_to adminpanel_path
    else
      render :edit
    end
  end     

  # DELETE /users/:id
  def destroy
    if current_user.admin?
      @user = User.find(params[:id])
      @user.destroy
    end

    redirect_to adminpanel_path
  end

  private

  def only_admin
    if current_user.nil? || current_user.admin == false
      redirect_to adminpanel_path
    end
  end

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :approved)
  end
end
