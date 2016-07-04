#controller file

require "sinatra"
require "sinatra/activerecord"
require "sinatra/flash"
require "./models"

enable :sessions
set :database, "sqlite3:database.sqlite3"

get "/" do
	@posting = Post.all.last(10) #shows last 10 posts
	erb :index
end

get "/account" do       
	@user = User.find(session[:user_id]) 
	@posting = @user.posts.all   #FAILED METHODS ---> #Post.find(session[:user_id])    #Post.all.current_user_id
	erb :account
end

get "/edit" do
	@user = User.find(session[:user_id]) 
	erb :edit
end

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
		flash[:notice] = "You've been signed in successfully. Welcome #{@user.name}, to the world of Glittr!"
		redirect "/account"
	else
		flash[:error] = "You need a valid sign-in to be Glittr'ed :("
		redirect "/login-failed"
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
  redirect "/sign-in"  #/post to page with posts
end

get "/login-failed" do 
	erb :login_failed
	# "login failed"
end
#############################################
get "/post" do
	erb :post
end

post "/post" do
	Post.create(
	posts: params[:post],
	user_id: session[:user_id] 
	)
	flash[:notice] = "You have posted."
	redirect "/account"
end
  # user = User.get(session[:user_id])
  # Post.create(:text)

#   # @post = Post.new(params) #find(session[:user_id]).create(
#   flash[:notice] = "You have posted."
#   redirect "/post"  #/post to page with posts
# end

#deletes the account that you're on  user where id 15.Post
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

# get "/profile" do
# 	@user = User.where(username: params[:username])
# 	erb :profile
# 	# @profile = Profile.find(params[:id])  #profile.age profile.name
# end

get "/profile/:id" do
	@user = User.find(params[:id])
	@posting = @user.posts.all
	erb :profile  #profile.age profile.name
end

# get "/sign-out" do 
# 	flash[:notice] = "You have signed out."
# 	redirect "/"
# end

get "/search" do
	erb :search
end

post "/search" do
	@user = User.where(username: params[:post]).first #@user = User.find(params[:id]) #@user = User.where(username: params[:username])
	@posting = @user.posts.all
	#@posting = @user.posts.all
	flash[:notice] = "You are being redirected."
	  #/post to page with posts
	erb :profile #redirect "/profile"
end

def current_user     
	if session[:user_id]       
		@current_user = User.find(session[:user_id])     
	end   
end