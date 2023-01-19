class ApplicationController < ActionController::Base
  before_action :authenticate_user!

  def disallow_admin
    if current_user.admin?
      flash[:alert] = "Only traders can perform this action."
      redirect_to adminpanel_path
    end
  end
  
end
