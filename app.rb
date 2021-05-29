require 'sinatra/base'
require './lib/encryption.rb'
require './models/user_profile.rb'
require './models/cat.rb'

class App < Sinatra::Base

# TODO: Figure out how to create session: human v human, human v computer
# TODO: Organize App.RB to have this

  enable :sessions

  # landing/login
  get '/' do
    if session[:email]
      erb :gamemenu
    else
      erb :login
    end
  end

  # signup
  get '/signup' do
    erb :signup
  end

  get '/login' do
    erb :login
  end

  get '/cat' do
    erb :catselection
  end

  get '/games/quiz' do
    erb :quiz
  end

  # cat selection
  post '/catselected' do
    selection = params[:input].to_i
    cats = Cat.load
    session[:profile_1].cat = cats[selection]
    puts session[:profile_1].cat
    puts session[:profile_1]
  end

  # signup submission
  post '/signup-filled' do
    session[:email] = params[:email]
    session[:password] = Encryption.encrypt(params[:password])
    session[:player_1] = UserProfile::User.create(session[:email], session[:password])
    player_1_profile = UserProfile::Player.new(session[:player_1])
    player_1_profile.save
    session[:player_2] = UserProfile::Player.computer
    redirect '/'
    end

  # login submission
  post '/login' do 
    session[:email] = params[:email]
    session[:password] = Encryption.encrypt(params[:password])
    session[:player_1] = UserProfile::User.login(session[:email], session[:password])
    session[:profile_1] = UserProfile::Player.login(session[:player_1], session[:email])
    redirect '/'
  end
end

App.run!