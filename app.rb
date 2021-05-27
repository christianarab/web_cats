require 'sinatra/base'
require './lib/encryption.rb'
require './models/user_profile.rb'

class App < Sinatra::Base

  enable :sessions

  # landing
  get '/' do
    if session[:email]
      erb :gamemenu
    else
      erb :login
    end
  end

  # sign-up
  get '/signup' do
    erb :signup
  end

  # filled post
  post '/signup-filled' do
    session[:email] = params[:email]
    session[:password] = Encryption.encrypt(params[:password])
    session[:player_1] = UserProfile::User.new(session[:email], session[:password]).save
    redirect '/'
  end

end

App.run!