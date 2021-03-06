#controller file

require "sinatra"
require "sinatra/activerecord"
require "sinatra/flash"
require "./models"

enable :sessions

configure(:development){set :database, "sqlite3:database.sqlite3"}

get "/" do
	@posting = Post.all.last(10).reverse! #shows last 10 posts top-down
	erb :index
end

get "/account" do       
	@user = User.find(session[:user_id]) 
	@posting = @user.posts.all.reverse_order!   
	erb :account
end

get "/edit" do
	@user = User.find(session[:user_id]) 
	erb :edit
end

#allows user to edit account attributes
post "/edit" do #post hides what would display in URL
	@user = User.find(session[:user_id]).update(
  	username: params[:username],
  	password: params[:password],
  	name: params[:name],
  	age: params[:age]
  	)
		flash[:notice] = "Consider your account edited."
		redirect "/account"
end

get "/sign-in" do
	erb :sign_in
end

post "/sign-in" do #post hides what would display in URL
	@user = User.where(username: params[:username]).first  #.first to get rid of array
	if @user && @user.password == params[:password]
		session[:user_id] = @user.id
		redirect "/account"
	else
		flash[:error] = "You need a valid sign-in to be Glittr'ed :("
		redirect "/sign-in"
	end
end

get "/sign-up" do
	erb :sign_up
end

#future: make so that signing up keeps you signed in
post "/sign-up" do
	User.create(
		username: params[:username],
		password: params[:password],
		name: params[:name],
		age: params[:age]
		)
	flash[:notice] = "You have signed up."
	redirect "/sign-in"  
end

get "/login-failed" do 
	erb :login_failed
end

get "/post" do
	erb :post
end

#creates a Glittr post
post "/post" do
	user = User.find(session[:user_id])
	Post.create(
	posts: params[:post],
	user_id: session[:user_id] 
	)
	redirect "/account"
end

#deletes the account that you're on 
get "/delete" do
	User.destroy(session[:user_id])
	session[:user_id] = nil
	flash[:notice] = "Your account is deleted."
	redirect "/sign-up"
end

get "/sign-out" do
	session[:user_id] = nil
	flash[:notice] = "You have signed out. Come back soon for more Glittr"
	redirect "/sign-in"
end

get "/follow/:id" do
	params.inspect#[:id]
	# follow.create(
	# 	follower_id: current_user_id,
	# 	followee_id: params[:id]
	# )
end

get "/profile/:id" do
	@user = User.find(params[:id])
	@posting = @user.posts.all
	erb :profile  
end

get "/error" do
	erb :error 
end

get "/search" do
	erb :search
end

#searches a user's profile by their username
post "/search" do
	@user = User.where(username: params[:post]).first 
	if @user == nil
		redirect "/error"
	else
		@posting = @user.posts.all.reverse_order!
		erb :profile 
	end
end

def current_user     
	if session[:user_id]       
		@current_user = User.find(session[:user_id])     
	end   
end