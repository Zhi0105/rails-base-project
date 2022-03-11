class AddHistPriceToTransactions < ActiveRecord::Migration[6.1]
  def change
    add_column :transactions, :hist_price, :float
  end
end
