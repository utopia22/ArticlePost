require 'rubygems'
# bundleに入れたgemを全てrequire
require 'bundler'
Bundler.require
# sinatra-contribのオートリロードしてくれるやつはrequireする必要がある
require 'sinatra/reloader'
# app.rbもrequireする
require './app.rb'

# /models,　/helpers配下のrubyファイルを全てrequireする
Dir[File.dirname(__FILE__) + '/models/*.rb'].each { |f| require f }
Dir[File.dirname(__FILE__) + '/helpers/*.rb'].each { |f| require f }

# database.ymlを読み込んでくれ〜
ActiveRecord::Base.configurations = YAML.load_file('database.yml')
# developmentを設定
ActiveRecord::Base.establish_connection(:development)
# タイムゾーンを東京にする
Time.zone = 'Tokyo'
ActiveRecord::Base.default_timezone = :local

run Sinatra::Application
