class RemoveSellAmountToPortfolio < ActiveRecord::Migration[6.1]
  def change
    remove_column :portfolios, :sell_amount
  end
end
