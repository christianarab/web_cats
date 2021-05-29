class Helpers
  class Profile
    def self.player_two?(session)
      if session
        true
      else
        nil
      end
    end

    def self.has_cat?(session)
      if session.cat
        true
      else
        nil
      end
    end
  end

  class Login
    def self.current_user(session)
      @user = User.find_by_id(session[:email])
      @user
    end

    def self.is_logged_in?(session)
      !!session[:email]
    end
  end

  class Score
    def self.winner_is?(p1=false, p2=false, player_1, player_2)
      if p1 == true
        player_2.losses += 1
        player_1.wins += 1
        player_1.tokens += 3
        player_1.pawz += 25
        puts "#{player_1.cat.name} total wins: #{player_1.wins}\n"
        puts "#{player_1.user.email} recieves 3 more tokens and 25 pawz. Tokens: #{player_1.tokens} Pawz: #{player_1.pawz}\n"
        Player.save(player_1)
        Player.save(player_2)
      elsif p2 == true
        player_1.losses += 1
        player_2.wins += 1
        player_2.tokens += 3
        player_2.pawz += 25
        puts "#{player_2.cat.name} total wins: #{player_2.wins}\n"
        puts "#{player_2.user.email} recieves 3 more tokens and 25 pawz. Tokens: #{player_2.tokens} Pawz: #{player_1.pawz}\n"
        Player.save(player_1)
        Player.save(player_2)
      else
        puts "It's a tie game!"
        player_1.wins += 1
        player_2.wins += 1
        player_1.tokens += 3
        player_2.tokens += 3
        Player.save(player_1)
        Player.save(player_2)
      end
    end
  end
end