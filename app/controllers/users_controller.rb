class UsersController < ApplicationController
  before_action :require_admin

  def adminpanel
    @users = User.where(admin: false)
  end

  def approve
    @users = User.where(admin: false, approved: false)
  end

  # def index
  #   @users = User.where(admin: false)
  # end

  # GET /users/new
  def new
    @user = User.new
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
    @user = User.find(params[:id])
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
  # def destroy
  #   if current_user.admin?
  #     @user = User.find(params[:id])
  #     @user.destroy
  #   end

  #   redirect_to adminpanel_path
  # end

  def approve_trader
    user = User.find(params[:user_id])
    user.update(approved: true)
    flash[:notice] = "User has been approved!"
    TraderAccountApprovalMailer.with(trader: user).trader_account_approved.deliver_now
    redirect_to approve_path
  end

  private

  def require_admin
    if !current_user.admin?
      flash[:alert] = "Only admin can perform such action."
      redirect_to my_portfolio_path
    end
  end

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :approved)
  end
end
