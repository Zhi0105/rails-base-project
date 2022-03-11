class RemoveRevenueFromPortfolios < ActiveRecord::Migration[6.1]
  def change
    remove_column :portfolios, :revenue, :float
  end
end
