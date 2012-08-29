# -*- coding: utf-8 -*-

require 'sinatra'
require 'date'
require 'kconv'

require 'rubygems'
require 'builder/xmlmarkup'
require 'twitter'

Twitter.configure do |config|
  config.consumer_key = ENV['CONSUMER_KEY']
  config.consumer_secret = ENV['CONSUMER_SECRET']
  config.oauth_token = ENV['OAUTH_TOKEN']
  config.oauth_token_secret = ENV['OAUTH_TOKEN_SECRET']
end

get '/' do
  'dialko-tweet'
end

get '/remind/:twitter_id' do
  content_type 'xml'
  xml = Builder::XmlMarkup.new
  xml.instruct! :xml, :version=>"1.0", :encoding=>"UTF-8"
  begin
    twitter_id = params[:twitter_id]
    raise "invalid twitter id" unless twitter_id =~ /^[a-zA-Z0-9_]+$/

    Twitter.update("@#{twitter_id} さま、#{Time.now.strftime('%H時%M分')}にお薬を飲まれましたね。")
    xml.dialko_response('status' => 'ok')
  rescue => exc
    xml.dialko_response('status' => 'fail') do
      xml.error exc.to_s
    end
  end
end
