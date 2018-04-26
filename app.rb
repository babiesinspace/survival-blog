require "sinatra"
require "sinatra/activerecord"
require "shotgun"

require_relative './models/user'
require_relative './models/post'
require_relative './models/comment'
require_relative './models/tag'
require_relative './models/taggedpost'
require_relative './models/like'

configure do
    enable :sessions unless test?
    set :session_secret, "secret"
end

set :database, {adapter: 'postgresql', database: 'blog'}

get '/' do 
  @admin = User.where(admin: true).first
  erb :index
end 