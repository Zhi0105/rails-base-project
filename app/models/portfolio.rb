class Portfolio < ApplicationRecord
  belongs_to :trader
  validates :unit, presence: true
end
