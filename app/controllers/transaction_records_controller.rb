class TransactionRecordsController < ApplicationController
  before_action :disallow_admin

  def index
    @transaction_records = current_user.transaction_records
  end
  
end

