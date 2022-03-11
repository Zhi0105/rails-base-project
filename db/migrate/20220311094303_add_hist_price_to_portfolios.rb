class AddHistPriceToPortfolios < ActiveRecord::Migration[6.1]
  def change
    add_column :portfolios, :hist_price, :float
  end
end
