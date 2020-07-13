require 'http'
require 'ogp'
require "sinatra"
require "sinatra/json"
require "sinatra/respond_with"
require "redis"

configure :development do
  require "sinatra/reloader"
  require "pry-byebug"
end

$redis = Redis.new

get '/' do
  url = params[:url]
  data = $redis.get(url)
  if data.nil?
    response = HTTP.follow.get(url)
    open_graph = OGP::OpenGraph.new(response.to_s)
    url = response.uri.to_s
    data = open_graph.data
    $redis.set(url, JSON.generate(data))
    $redis.expire(url, 60 * 60 * 24)
  else
    data = JSON.parse(data)
  end
  json(data: data, url: url)
rescue OGP::MissingAttributeError
  json(error: "No og: attributes found for this website")
rescue StandardError => e
  json(error: e.message)
end
