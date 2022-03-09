class Portfolio < ApplicationRecord
  belongs_to :trader
  validates :unit, presence: true
  validates :sell_amount, presence: true
end
