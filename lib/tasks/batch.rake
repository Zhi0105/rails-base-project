namespace :batch do
  desc 'TODO'
  task update_stocks: :environment do
    client = IEX::Api::Client.new(
      publishable_token: Rails.application.credentials.iex_global_api[:publishable],
      secret_token: Rails.application.credentials.iex_global_api[:secret],
      endpoint: 'https://sandbox.iexapis.com/v1'
    )

    logger = Logger.new($stdout)
    # open text file for list of available markets in API
    file = File.open('app/api/stock_lists/market_symbol.txt')
    file_data = file.readlines.map(&:chomp)

    # Loop through each market to update data
    file_data.each do |data|
      market = Market.find_by(market_symbol: data)
      logger.info "Updating #{market.name}"
      market.curr_price = client.price(data) * 52.25
      market.save

    rescue StandardError
      nil
    end
  end
end
