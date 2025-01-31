class AdminsController < ApplicationController
  def index
    @traders = Trader.where(is_approved: true)
  end

  def transaction
    @transactions = Transaction.all.order('created_at ASC')
  end

  def for_approval
    @traders = Trader.where(is_approved: false)
    @balance_request = BalanceRequest.where(is_approved: false)
  end

  def approved
    @trader = Trader.find(params[:id])
    @trader.is_approved = true
    if @trader.save
      UserMailer.welcome_email(@trader.email).deliver_now
      redirect_to for_approval_path, notice: 'success'
    else
      render :for_approval, notice: 'failed'
    end
  end

  def new_trader
    @trader = Trader.new
  end

  def create_new_trader
    @trader = Trader.new(trader_params)
    @trader.is_approved = true

    if @trader.save

      redirect_to admin_dashboard_path, notice: 'success'
    else

      render :new_trader, notice: 'failed', status: :unprocessable_entity
    end
  end

  def show_trader
    @trader = Trader.find(params[:id])
    @transactions = @trader.transactions
  end

  def edit_trader
    @trader = Trader.find(params[:id])
  end

  def update_trader
    @trader = Trader.find(params[:id])

    if @trader.update(params.require(:trader).permit(:username, :fullname))
      redirect_to admin_show_trader_path(id: @trader.id)
    else
      render :edit_trader
    end
  end

  def approved_balance_request
    @balance_request = BalanceRequest.find(params[:id])
    @wallet = Wallet.find_by(trader_id: @balance_request.trader_id)
    if @wallet.nil?
      render :for_approval, notice: 'failed'
    else
      @balance_request.is_approved = true
      @balance_request.save
      @wallet.balance = @wallet.balance + @balance_request.amount
      @wallet.save
      redirect_to for_approval_path, notice: 'success'
    end
  end

  private

  def trader_params
    params.require(:trader).permit(:username, :fullname, :email, :password)
  end
end
