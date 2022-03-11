class AddRevenueToTransactions < ActiveRecord::Migration[6.1]
  def change
    add_column :transactions, :revenue, :float
  end
end
