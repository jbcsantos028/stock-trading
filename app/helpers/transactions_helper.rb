module TransactionsHelper

  def build_form_with_attributes(owned_stock, stock)
    attributes = {}

    if current_user.stock_already_owned?(stock.symbol)
      attributes[:location] = "/transactions/#{owned_stock.id}"
      attributes[:method_type] = :patch
    else
      attributes[:location] = :transactions
      attributes[:method_type] = :post
    end

    if @transaction_type_sell == "True"
      attributes[:text_field_placeholder] =  "Number of shares to sell..."
      attributes[:submit_button_label] = "Sell #{stock.name}"
    else
      attributes[:text_field_placeholder] =  "Number of shares to buy..."
      attributes[:submit_button_label] = "Buy #{stock.name}"
    end
    attributes
    
  end

end
