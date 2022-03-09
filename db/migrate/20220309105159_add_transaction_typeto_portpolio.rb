class AddTransactionTypetoPortpolio < ActiveRecord::Migration[6.1]
  def change
    add_column :portfolios, :transaction_type, :string
  end
end
