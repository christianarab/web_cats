require 'sinatra/base'
require './lib/encryption.rb'
require './models/user_profile.rb'
require './models/cat.rb'
require './models/competition.rb'

class App < Sinatra::Base

  enable :sessions

  # landing/login
  get '/' do
    if session[:profile_1]
      erb :gamemenu
    else
      erb :login
    end
  end

  # signup
  get '/signup' do
    erb :signup
  end

  # logout
  get '/logout' do
    session[:profile_1], session[:profile_2] = nil
    redirect '/'
  end
  
  # select cat
  get '/cat' do
    erb :catselection
  end

  # cat selection
  post '/catselected' do
    selection = params[:input].to_i
    cats = Cat.load
    session[:profile_1].cat = cats[selection]
    redirect'/'
  end

  # cat save
  get '/save-cat' do
    session[:profile_1].save_cat
    redirect '/'
  end
  
  # quiz: gives 50 pawz per correct answer
  get '/games/quiz' do
    erb :quiz
  end
  
  post '/games/quiz/done' do
    answers = ["True", "True", "Clowder", "230", "Kindle", "43", "2-3", "12", "True"]

    submission = [params[:q1], 
                  params[:q2], 
                  params[:q3], 
                  params[:q4], 
                  params[:q5], 
                  params[:q6], 
                  params[:q7], 
                  params[:q8], 
                  params[:q9]]

    @quiz_results = answers.each_with_index.map do |answer, idx|
        if submission[idx] == answer
          session[:profile_1].pawz += 50
          "You are correct"
        else
          "Try again"
        end
      end
    session[:quizresults] = @quiz_results
    redirect '/games/quiz/done'
  end

  get '/games/quiz/done' do
    erb :quiz
  end

  # competition games
  get '/games/competition' do
    erb :competition
  end

  post '/comp-move' do
    @results = []
    @selection = [params[:move1], params[:move2], params[:move3], params[:move4], params[:move5]]
    @results = @selection.each.map do |move|
      Competition::Roll.move_winner?(move, session[:profile_1], session[:profile_2])
    end
    puts @results
    session[:competitionresult] = @results
    redirect "/games/competition"
  end

  # pawz mart
  get '/pawzmart' do
    erb :pawzmart
  end

  get '/pawzmart/tunashake' do
    if session[:profile_1].pawz < 300
      session[:pawzerr] = "You do not have enough pawz to buy"
      redirect '/pawzmart'
    else
      session[:profile_1].pawz -= 300
      session[:profile_1].cat.add_agility
      redirect '/pawzmart'
    end
  end

  get '/pawzmart/catnip' do
    if session[:profile_1].pawz < 150
      session[:pawzerr] = "You do not have enough pawz to buy"
      redirect '/pawzmart'
    else
      session[:profile_1].pawz -= 150
      session[:profile_1].cat.add_confidence
      redirect '/pawzmart'
    end
  end

  get '/pawzmart/beyondmice' do
    if session[:profile_1].pawz < 400
      session[:pawzerr] = "You do not have enough pawz to buy"
      redirect '/pawzmart'
    else
      session[:profile_1].pawz -= 400
      session[:profile_1].cat.add_str
      redirect '/pawzmart'
    end
  end

  # signup submission
  post '/signup-filled' do
    session[:email] = params[:email]
    session[:password] = Encryption.encrypt(params[:password])
    session[:profile_1] = UserProfile::User.create(session[:email], session[:password])
    player_1_profile = UserProfile::Player.new(session[:player_1])
    player_1_profile.save
    session[:profile_2] = UserProfile::Player.computer
    redirect '/'
    end

  # login submission
  post '/login' do 
    if Helpers::Login.find_by(params[:email]) == false
      session[:email_error] = true
      redirect '/'
    else
      session[:email] = params[:email]
      session[:password] = Encryption.encrypt(params[:password])
      session[:player_1] = UserProfile::User.login(session[:email], session[:password])
      session[:profile_1] = UserProfile::Player.login(session[:player_1], session[:email])
      session[:profile_2] = UserProfile::Player.computer
      redirect '/'
    end
  end
end

App.run!