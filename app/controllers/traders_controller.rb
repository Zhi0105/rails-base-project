class TradersController < ApplicationController
  before_action :authenticate_trader!

  def index
    @trader = Wallet.find_by(trader_id: current_trader.id)
    @portfolios = current_trader.Portfolios.all.order('market_symbol ASC')
    
    @profit_and_loss = 0
    current_portfolio_price = 0
    history_price = 0
    if @portfolios.length.positive?
      @portfolios.each do |p|
        market = Market.find_by(market_symbol: p.market_symbol)
        current_portfolio_price += (market.curr_price * p.unit)
        history_price += (p.hist_price * p.unit)
      end
    end

    @profit_and_loss = (current_portfolio_price - history_price).round(2)
  end

  def show; end
end
