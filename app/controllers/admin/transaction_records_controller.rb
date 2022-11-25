class Admin::TransactionRecordsController < ApplicationController
    def index
        @transaction_records = Transaction.all
    end
end