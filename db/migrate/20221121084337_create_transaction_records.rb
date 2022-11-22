class CreateTransactionRecords < ActiveRecord::Migration[6.1]
  def change
    create_table :transaction_records do |t|
      t.string :stock_symbol
      t.string :company_name
      t.decimal :shares
      t.decimal :price
      t.string :transaction_type
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
