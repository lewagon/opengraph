require 'http'
require 'ogp'
require "sinatra"
require "sinatra/json"
require "redis"

configure :development do
  require "sinatra/reloader"
end

$redis = Redis.new
USER_AGENT = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0) Gecko/20100101 Firefox/78.0'

get '/' do
  url = params[:url]
  if url.nil? || url == ""
    status 422
    json(error: "Please provide a URL to scrape", example_url: "https://opengraph.lewagon.com/?url=https://www.lewagon.com")
  else
    data = $redis.get(url)
    if data.nil?
      response = HTTP.follow.headers('Accept-Language' => 'en-US', 'User-Agent' => USER_AGENT).get(url)
      open_graph = OGP::OpenGraph.new(response.to_s)
      url = response.uri.to_s
      data = open_graph.data
      $redis.set(url, JSON.generate(data))
      $redis.expire(url, 60 * 60 * 24)
    else
      data = JSON.parse(data)
    end
    json(data: data, url: url)
  end
rescue StandardError => e
  status 500
  json(error: e.message, url: url)
end
