require "sinatra"
require "sinatra/activerecord"
require "shotgun"

require_relative './models/user'
require_relative './models/post'
require_relative './models/comment'
require_relative './models/tag'
require_relative './models/taggedpost'

set :database, {adapter: 'postgresql', database: 'blog'}