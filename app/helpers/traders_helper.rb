module TradersHelper
  def get_current_value(portfolio)
    market = Market.find_by(market_symbol: portfolio.market_symbol)
    (market.curr_price * portfolio.unit)
  end
end
