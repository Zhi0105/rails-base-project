module ApplicationHelper
    def get_market_name(sym)
        Market.find_by(market_symbol: sym).name
    end
    def get_market_price(sym)
        Market.find_by(market_symbol: sym).curr_price
    end
    
end
