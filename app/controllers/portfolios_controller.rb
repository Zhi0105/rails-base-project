class PortfoliosController < ApplicationController
  before_action :authenticate_trader!

  def new
    @portfolio = current_trader.portfolios.build
    @market = Market.find(params[:id])
    @wallet = current_trader.wallet
  end

  def create; end
end
