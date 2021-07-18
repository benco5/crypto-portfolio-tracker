class HomeController < ApplicationController

  def index
    @coins = helpers.crypto_listings_api_call
    @topranked = @coins.select { |coin| coin["cmc_rank"] <= 12 }.sort_by { |coin| coin['cmc_rank'] }
  end

  def about
  end

  def lookup
    @symbol = params[:crypto_symbol]
    if @symbol
      @coins = helpers.crypto_listings_api_call
      @coin = @coins.select { |coin| coin["symbol"] == @symbol.upcase}[0] || {}
    end
  end
end
