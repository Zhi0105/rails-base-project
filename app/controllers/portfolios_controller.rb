class PortfoliosController < ApplicationController
  before_action :authenticate_trader!

  def new
    @market = Market.find(params[:id])
    @wallet = current_trader.wallet
    @portfolio = current_trader.Portfolios.build
  end

  def sell
    @portfolio = current_trader.Portfolios.find(params[:id])
    @wallet = current_trader.wallet
  end

  def create
    @market = Market.find(params[:id])
    @wallet = current_trader.wallet

    is_market_available = current_trader.Portfolios.find_by(market_symbol: params[:portfolio][:market_symbol])
    portfolio_transaction_logic(is_market_available)
  end

  def update
    @portfolio = current_trader.Portfolios.find(params[:id])
    @wallet = current_trader.wallet

    portfolio_sell_logic
  end

  private

  def portfolio_params
    params.require(:portfolio).permit(:unit, :market_id, :market_symbol, :transaction_type, :revenue)
  end

  def portfolio_transaction_logic(is_market_available)
    @trader_wallet = current_trader.wallet
    case params[:portfolio][:transaction_type]
    when 'BUY'
      portfolio_buy_logic(is_market_available)
    end
  end

  def portfolio_buy_logic(is_market_available)
    if is_market_available.nil?
      @portfolio = current_trader.Portfolios.build(portfolio_params)
      @portfolio.revenue = params[:portfolio][:revenue].to_f.round(2) * params[:portfolio][:unit].to_f.round(2)
      @trader_wallet.balance = current_trader.wallet.balance - (params[:portfolio][:revenue].to_f.round(2) * params[:portfolio][:unit].to_f.round(2))
      @portfolio.save if @trader_wallet.balance.positive?
      portfolio_buy_logic_update(@trader_wallet, @portfolio)
    else
      @portfolio = is_market_available
      @portfolio.unit += params[:portfolio][:unit].to_i
      @portfolio.revenue = @portfolio.revenue.to_f.round(2) + (params[:portfolio][:revenue].to_f.round(2) * params[:portfolio][:unit].to_f.round(2)).to_f.round(2)
      @trader_wallet.balance = current_trader.wallet.balance - (params[:portfolio][:revenue].to_f.round(2) * params[:portfolio][:unit].to_f.round(2))
      @portfolio.save if @trader_wallet.balance.positive?
      portfolio_buy_logic_create(@trader_wallet, @portfolio)
    end
  end

  def portfolio_buy_logic_update(trader_wallet, portfolio)
    if trader_wallet.balance.positive?
      if portfolio.save
        trader_wallet.save
        create_transaction_log_buy
        redirect_to trader_portfolio_path, notice: 'Successfully bought stocks'
      else
        render :new
      end
    else
      redirect_back fallback_location: :trader_portfolio_path, notice: 'Please check if balance is sufficient.'
    end
  end

  def portfolio_buy_logic_create(trader_wallet, portfolio)
    if trader_wallet.balance.positive?
      if portfolio.save
        trader_wallet.save
        create_transaction_log_buy
        redirect_to trader_portfolio_path, notice: 'Successfully bought stocks'
      else
        render :new
      end
    else
      redirect_back fallback_location: :trader_portfolio_path, notice: 'Please check if balance is sufficient.'
    end
  end

  def portfolio_sell_logic
    if @portfolio.unit.to_i == 0
      redirect_back fallback_location: :trader_portfolio_path, notice: 'check your unit stock if available.'
    else
      @portfolio.unit = (@portfolio.unit - params[:portfolio][:unit].to_f)
      @portfolio.revenue = @portfolio.revenue - (params[:portfolio][:unit].to_f * params[:portfolio][:revenue].to_f)
      @wallet.balance = current_trader.wallet.balance + (params[:portfolio][:unit].to_f * params[:portfolio][:old_revenue].to_f).to_f
      @wallet.save
      @portfolio.revenue.negative? ? @portfolio.destroy : @portfolio.save
      create_transaction_log_sell
      redirect_to trader_portfolio_path, notice: 'Stock successfully sold!'
    end
  end

  def create_transaction_log_buy
    Transaction.create(
      trader_id: current_trader.id,
      portfolio_id: @portfolio.id,
      transaction_type: params[:portfolio][:transaction_type],
      market_symbol: params[:portfolio][:market_symbol],
      unit: params[:portfolio][:unit],
      revenue: (params[:portfolio][:revenue].to_f * params[:portfolio][:unit].to_f).to_s
    )
  end

  def create_transaction_log_sell
    Transaction.create(
      trader_id: current_trader.id,
      portfolio_id: @portfolio.id,
      transaction_type: params[:portfolio][:transaction_type],
      market_symbol: params[:portfolio][:market_symbol],
      unit: params[:portfolio][:unit],
      revenue: (params[:portfolio][:revenue].to_f * params[:portfolio][:unit].to_f).to_s
    )
  end
end
