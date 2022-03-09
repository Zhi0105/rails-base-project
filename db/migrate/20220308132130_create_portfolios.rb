class CreatePortfolios < ActiveRecord::Migration[6.1]
  def change
    create_table :portfolios do |t|
      t.references :trader, null: false, foreign_key: true
      t.references :market, null: false, foreign_key: true
      t.integer :unit, null: false
      t.float :revenue
      t.float :sell_amount
      t.timestamps
    end
  end
end
