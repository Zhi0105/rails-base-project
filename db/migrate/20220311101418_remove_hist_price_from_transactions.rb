class RemoveHistPriceFromTransactions < ActiveRecord::Migration[6.1]
  def change
    remove_column :transactions, :hist_price, :float
  end
end
