module ApplicationHelper
  def crypto_listings_api_call
    @url = "https://pro-api.coinmarketcap.com/v1/cryptocurrency/listings/latest?CMC_PRO_API_KEY=#{ENV['CMC_PRO_API_KEY']}"
    @uri = URI(@url)
    @response = Net::HTTP.get(@uri)
    return @coins = JSON.parse(@response)["data"]
  end
end
