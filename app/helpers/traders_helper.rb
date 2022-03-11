module TradersHelper
  def get_current_value(portfolio)
  market = Market.find_by(market_symbol: portfolio.market_symbol)
  return (market.curr_price * portfolio.unit)
  end
end
