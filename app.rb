#controller file
 
require "sinatra"
require "sinatra/activerecord"
require "sinatra/flash"
require "./models"

enable :sessions
set :database, "sqlite3:database.sqlite3"

get "/" do
	erb :index
end


get "/sign-in" do
	erb :sign_in
end

post "/sign-in" do #post hides what would display in URL
	@user = User.where(username: params[:username]).first  #.first to get rid of array
	if @user && @user.password == params[:password]
		session[:user_id] = @user.id
		flash[:notice] = "You've been signed in successfully."
		redirect "/"
	else
		flash[:error] = "FAILED SIGN IN."
		redirect "/login-failed"
	#params.inspect #puts
	end
end

get "/sign-up" do
	erb :sign_up
end

post "/sign-up" do
  User.create(
  	username: params[:username],
  	password: params[:password],
  	bday: params[:bday],
  	name: params[:name]
  	)
  flash[:notice] = "You have signed up."
  redirect "/"  #/post to page with posts
end

get "/login-failed" do 
	erb :login_failed
	# "login failed"
end

def current_user     
	if session[:user_id]       
		@current_user = User.find(session[:user_id])     
	end   
end