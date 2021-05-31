require_relative 'cat.rb'

module UserProfile 
  class User
    attr_reader :email, :encrypted_password

    def initialize(email, password)
      @email, @encrypted_password = email, Encryption.encrypt(password)
    end

    def self.create(email, password)
      if User.find_by(email).instance_of?(User) == true
        print "Email already exists! Please use a different email"
        create
      else
        password = Encryption.encrypt(password)
        User.new(email, password)
      end
    end

    def save
      File.open('./data/accounts', 'a') do |file|
        file.write("#{@email}, #{@encrypted_password}\n")
      end
    end

    def self.login(email, password)
      user = User.find_by(email)
      if user.nil? == true
        puts "There is no user try again."
      elsif user.encrypted_password == Encryption.encrypt(password)
        user
      else
        raise StandardError.new("This password is not correct.")
      end
    end

    def self.find_by(email)
      File.open('./data/accounts', 'r') do |file|
        file.map do |line|
          user_email, encrypted_password = line.split(', ')
          if user_email == email
            return User.new(user_email, encrypted_password.chomp)
          else
          end
        end
      end
      nil
    end
  end

  class Player
    attr_accessor :user, :cat, :pawz, :tokens, :wins, :losses, :competition_wins, :score
    
    def initialize(user, pawz=400, tokens=5, wins=0, losses=0, competition_wins=0)
      @user = user
      @pawz = pawz
      @tokens = tokens
      @wins = wins
      @losses = losses
      @competition_wins = competition_wins
      @cat = nil
      @score = 0
    end
  
    # Instantiates computer profile.
    def self.computer
      @cats = Cat.load
      computer = Player.new(User.new("Computer","Password"), pawz=400, tokens=5, wins=0, losses=0, competition_wins=0)
      computer.cat = @cats[rand(0..3)]
      computer
    end
  
    # Selects cat by email account
    def select_cat(email)
      @cats = Cat.load
  
      if File.file?("./data/cats/#{email}_cat")
        f = File.open("./data/cats/#{email}_cat", 'r') 
        name, size, energy, confidence, agility, strength = f.readlines[0].split(", ")
        @cat = Cat.new(name, size.to_s, energy.to_i, confidence.to_i, agility.to_i, strength.to_i)
      else
        puts "No cat found!"
        puts "Please select a cat:"
        puts "no.\t\tname\t\tsize\t\tconfidence\t\tagility\t\tstrength\n"
        @cats.each_with_index do |cat, idx|
          puts "#{idx+1}.\t\t#{cat.name}\t\t#{cat.size}\t\t#{cat.confidence}\t\t\t#{cat.agility}\t\t#{cat.strength}"
        end
        user_input = gets.chomp.to_i
        @cat = @cats[user_input-1]
      end
    end
  
    def save
      File.open("./data/profiles/#{user.email}", 'w') do |file|
        file.write("#{user.email}, #{@pawz}, #{@tokens}, #{@wins}, #{@losses}, #{@competition_wins}\n")
      end                
    end

    # Saves account cat
    def save_cat
      File.open("./data/profiles/#{user.email}_cat", 'w') do |file|
        file.write("#{self.cat.name}, #{self.cat.size}, #{self.cat.energy}, #{self.cat.confidence}, #{self.cat.agility}, #{self.cat.strength}\n")
      end
    end
  
    def self.login(user, email)
      f = File.open("./data/profiles/#{email}", "r")
      email, pawz, tokens, wins, losses, competition_wins = f.readlines[0].split(",")
      player = Player.new(user, pawz.to_i, tokens.to_i, wins.to_i, losses.to_i, competition_wins.to_i)
    end
  
    # Greeting messages according to hour of day
    def self.greet
      def self.range
        if Time.now.hour < 12
          "morning"
        elsif Time.now.hour < 17
          "afternoon"
        elsif Time.now.hour < 21
          "evening"
        else
          "night"
        end
      end
  
      greetings = {
        "morning" => "Meow! Morning! I want a can of tuna.",
        "afternoon" => "Good after noon whiskers.",
        "evening" => "Good evening, purrrrrrrrr",
        "night" => "Meow time for some catnip and bed"
      }
      
      "#{greetings[range]}\n"
    end
  
    def to_s
      "user.email: #{@user.email}, paw points: #{@pawz}, tokens: #{@tokens}, wins: #{@wins}, losses: #{@losses}, competition wins: #{@competition_wins}, cat: #{@cat}"
    end
  end
end
