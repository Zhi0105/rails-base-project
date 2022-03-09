class TradersController < ApplicationController
  before_action :authenticate_trader!

  def index
    @trader = Wallet.find_by(trader_id: current_trader.id)
    @portfolios = current_trader.Portfolios.all.order('market_symbol ASC')
    @total = current_trader.Portfolios.sum(:revenue)
  end

  def show; end
end
