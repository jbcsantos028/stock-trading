class Admin::TransactionRecordsController < ApplicationController
    before_action :require_admin
    
    def index
        @transaction_records = TransactionRecord.all
    end

    def require_admin
        if !current_user.admin?
          flash[:alert] = "Only admin can perform such action."
          redirect_to my_portfolio_path
        end
      end
end