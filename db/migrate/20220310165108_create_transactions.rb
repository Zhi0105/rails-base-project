class CreateTransactions < ActiveRecord::Migration[6.1]
  def change
    create_table :transactions do |t|
      t.references :trader, null: false, foreign_key: true
      t.integer :portfolio_id
      t.string :transaction_type
      t.string :market_symbol
      t.float :revenue
      t.integer :unit
      t.timestamps
    end
  end
end
