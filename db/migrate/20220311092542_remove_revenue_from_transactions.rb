class RemoveRevenueFromTransactions < ActiveRecord::Migration[6.1]
  def change
    remove_column :transactions, :revenue, :string
  end
end
