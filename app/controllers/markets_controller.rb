class MarketsController < ApplicationController
  before_action :authenticate_trader!
  def index
    @markets = Market.all.order('market_symbol ASC')
  end
end
