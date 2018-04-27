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
  @posts = Post.limit(5)
  erb :index
end 

get '/logout' do 
  session.clear
  redirect '/'
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
    redirect "/users/profile"
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

get '/comments' do 
  @comments = Comment.order("updated_at").last(20).reverse
  erb :'comments/index'
end 

post '/comments/:id/like' do 
  @comment = Comment.find(params[:id])
  if session[:id] 
    @user = User.find(session[:id])
    @comment.likes.create(user: @user)
  else 
    @comment.likes.create
  end
  redirect "/comments"
end

post '/comments/:id/new' do 
  @commentable = Comment.find(params[:id])
  @comment = @commentable.comments.new(content: params[:content])
  if @comment.save
    @msg = "Saved"
    redirect "/comments"
  else
    @errors = @comment.errors
    redirect "/comments"
  end
end  

get '/posts/:id' do 
  @user = User.find(session[:id])
  @post = Post.find(params[:id])
  erb :'posts/show'
end

get '/tags' do 
  @tags = Tag.all
  erb :'tags/index'
end  
