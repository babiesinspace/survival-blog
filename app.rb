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

get '/users/login' do 
  erb :login
end 

get '/register/new' do 
  erb :register
end 

post '/register' do
  @user = User.new(name: params[:name], password: params[:password], handle: params[:handle], email: params[:email])

  if @user.save
    session[:id] = @user.id
    redirect "/user/profile"
  else
    # check this
    @errors = @user.errors
    redirect "/failure"
  end

end

post '/login' do
  #nice to have: find by email or handle
  @user = User.find_by(email: params[:email])

  if @user.authenticate(params[:password])
    session[:id] = @user.id
    redirect "/user/profile"
  else
    # check this
    @errors = @user.errors
    redirect "/failure"
  end

end

# see your recent comments/likes
get '/users/profile' do
  @user = User.find(session[:id]) 
  erb :profile
end 

# see someone else's recent comments/likes
get '/users/:id' do 
  @user = User.find(params[:id])
  erb :'users/show'
end 

