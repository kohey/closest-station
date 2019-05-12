require 'bundler/setup'
Bundler.require
require 'sinatra/reloader' if development?
require 'open-uri'
require 'json'
require 'net/http'

get '/' do 
    erb :form
end

# 座標から最寄駅
get '/list' do
    uri =URI("http://express.heartrails.com/api/json")
    uri.query = URI.encode_www_form({
        method: "getStations",
       x: params[:x],
       y: params[:y]
       })
    # method=getStations&x=135.504123&y=34.547111
    @x_query = params[:x]
    @y_query = params[:y]
    res = Net::HTTP.get_response(uri)
    json = JSON.parse(res.body)
    @stations = json["response"]["station"]
    erb :list
end

#入力駅から次の駅
get '/api/station' do
    uri = URI.parse("http://express.heartrails.com/api/json")
    uri.query = URI.encode_www_form({
        method: "getStations",
        line: params[:line],
        name: params[:name]
    })
    
    res = Net::HTTP.get_response(uri)
    json = JSON.parse(res.body)
    
    if json["response"]["error"]
        response = {error: "NO STATION"}
    else
        response = {
        next: json["response"]["station"][0]["next"],
        prev: json["response"]["station"][0]["prev"]
        }
    end
    
    json response
end




