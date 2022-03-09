class AddMarketSymbolToPortfolio < ActiveRecord::Migration[6.1]
  def change
    add_column :portfolios, :market_symbol, :string
  end
end
