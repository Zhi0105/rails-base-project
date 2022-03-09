class ChangeMarketReferenceOnPortfolio < ActiveRecord::Migration[6.1]
  def change
    remove_column :portfolios, :market_id
    add_column :portfolios, :market_id, :integer
  end
end
