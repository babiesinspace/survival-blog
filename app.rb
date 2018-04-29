require "sinatra"
require "sinatra/activerecord"
require "shotgun"
require 'sinatra/partial'

require_relative './models/user'
require_relative './models/post'
require_relative './models/comment'
require_relative './models/tag'
require_relative './models/taggedpost'
require_relative './models/like'

configure do
    enable :sessions unless test?
    set :session_secret, "secret"
    set :partial_template_engine, :erb
end

set :database, {adapter: 'postgresql', database: 'survival'}

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
    redirect "/users/profile"
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
  @user = User.find(session[:id]) if session[:id] 
  erb :profile
end 

get '/users/profile/edit' do 
  @user = User.find(session[:id]) if session[:id]
  if @user 
    erb :'/users/edit'
  else 
    redirect ("/")
  end  
end

put '/users/profile' do 
  @user = User.find(session[:id]) if session[:id]
  if @user 
    @user.update(name: params[:name], email: params[:email], handle: params[:handle], password: params[:password])
  else 
    @errors = @user.errors
  end 
  redirect ("/users/profile")
end 

delete '/users/profile' do 
  @user = User.find(session[:id]) if session[:id]
  @user.destroy
  session.clear
  redirect ("/")
end

# see someone else's recent comments/likes
get '/users/:id' do 
  @user = User.find(params[:id])
  erb :'users/show'
end 

get '/comments' do
  @user = User.find(session[:id]) if session[:id]
  @comments = Comment.hash_tree(limit_depth: 20)
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

delete '/comments/:id/like' do 
  @user = User.find(session[:id]) if session[:id]
  @like = Like.find_by(likable_type: "Comment", likable_id: params[:id], user_id: @user.id)
  @like.destroy
  redirect "/comments"
end

post '/comments/:id/new' do
  @user = User.find(session[:id]) if session[:id] 
  if @user 
    if params[:comment_id] 
      @commentable = Comment.find(params[:comment_id])
      @comment = @commentable.children.new(content: params[:content], author: @user)
    elsif params[:post_id]
      @commentable = Post.find(params[:post_id])
      @comment = @commentable.children.new(content: params[:content], author: @user)
    end
  end 
  if @comment.save
    @msg = "Saved"
  else
    @errors = @comment.errors
  end
  redirect "/comments"
end

put '/comments/:id/edit' do 
  @user = User.find(session[:id]) if session[:id]
  @comment = Comment.find(params[:id])
  if @comment.author == @user 
    @comment.update(content: params[:content])
  end 
  redirect ("/posts/#{params[:post]}") if !params[:post].nil?
  redirect ("/comments") if !params[:comments].nil?
  redirect ("/")
end

delete '/comments/:id' do 
  @user = User.find(session[:id]) if session[:id]
  @comment = Comment.find(params[:id])
  if @comment.author == @user 
    @comment.destroy
  end
  redirect ("/posts/#{params[:post]}") if !params[:post].nil?
  redirect ("/comments") if !params[:comments].nil? 
  redirect ("/")
end  

get '/posts/:id' do 
  @user = User.find(session[:id]) if session[:id]
  @post = Post.find(params[:id])
  erb :'posts/show'
end

post '/posts/:id/like' do 
  @post = Post.find(params[:id])
  if session[:id] 
    @user = User.find(session[:id])
    @post.likes.create(user: @user)
  else 
    @post.likes.create
  end
  redirect '/' if params[:home] == "home"
  redirect ("/posts/#{params[:id]}")
end

post '/posts/:id/comments/new' do
  @user = User.find(session[:id]) if session[:id]
  if @user 
    @commentable = Post.find(params[:id])
    @comment = @commentable.comments.new(content: params[:content], author: @user)
    if @comment.save
      @msg = "Saved"
    else
      @errors = @comment.errors
    end
  else 
    @msg = "You must be logged in to leave a comment!"
  end 
  redirect "/posts/#{params[:id]}"
end

post "/posts/:id/comments/:comment_id/like" do
  @comment = Comment.find(params[:likable_id])
  if session[:id] 
    @user = User.find(session[:id])
    @comment.likes.create(user: @user)
  else 
    @comment.likes.create
  end
  redirect '/' if params[:home] == "home"
  redirect back
end



get '/tags' do
  @user = User.find(session[:id]) if session[:id] 
  @tags = Tag.all
  erb :'tags/index'
end

get '/tags/:id' do
  @user = User.find(session[:id]) if session[:id] 
  @tag = Tag.find(params[:id])
  erb :'tags/show'
end  
