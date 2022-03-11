class TransactionsController < ApplicationController
  before_action :authenticate_trader!
  def index
    @transactions = current_trader.transactions.order('created_at ASC')
  end
end
