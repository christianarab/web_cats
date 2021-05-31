class Competition
  class Roll
    attr_reader :move, :profile
    attr_accessor :result
    def initialize(move, profile)
      @profile = profile.cat.name
      @move = move
      @result =
      case move
      when 'attack'
        roll_dice * profile.cat.strength
      when 'defence'
        roll_dice * profile.cat.agility
      end
    end

    def roll_dice
      rand(1..6)
    end
    
    def self.move_winner?(move, profile_1, profile_2)
      move_1 = Roll.new(move, profile_1)
      automated_move = ['attack','defence'].sample
      move_2 = Roll.new(automated_move, profile_2)

      if move_1.result > move_2.result 
        outcome = "#{move_1.profile} #{move_1.move} dealt #{move_1.result} against #{move_2.profile}"
        'successful'
      elsif move_2.result > move_1.result 
        outcome = "#{move_2.profile} #{move_2.move} dealt #{move_2.result} against #{move_1.profile}"
        'defence'
      else
        outcome = "#{move_1.profile} and #{move_2.profile} did no damage to each other."
        'rejected'
      end
    end    
  end

  # def self.competition_logic(move, player_1, player_2)
  #   p1_move = move
  #   p2_move = ['attack', 'defence'].sample
  #   if p1_move && p2_move == 'attack'
  #     if player_1.cat.strength > player_2.cat.strength
  #       player_2.cat.energy -= 25
  #       "successful"  
  #     else player_1.cat.strength < player_2.cat.strength
  #       player_1.cat.energy -= 25
  #       "rejected"
  #     end
  #   elsif p1_move == 'attack' && p2_move == 'defence'
  #     if player_1.cat.strength > player_2.cat.agility
  #       player_2.cat.energy -= 25
  #       "successful"
  #     else
  #       player_1.cat.energy -= 25
  #       "rejected"
  #     end
  #   elsif p2_move == 'attack' && p1_move == 'defence'
  #     if player_2.cat.strength > player_1.cat.agility
  #       player_1.cat.energy -= 25
  #       "rejected"
  #     else
  #       player_2.cat.energy -= 25
  #       "successful"
  #     end
  #   elsif p2_move == 'defence' && p1_move == 'defence' 
  #     "neutral"
  #   elsif p1_move == 'forfeit'
  #     player_1.cat.energy -= 100
  #   elsif p2_move == 'forfeit'
  #     player_2.cat.energy -= 100
  #   else
  #     "error"
  #   end
  # end

  def self.competition_mode(player_1, player_2)
    if player_1.tokens < 3 
      puts "#{player_1.user.email}: You need to earn more tokens!"
    else
      player_1.tokens -= 3
      player_2.tokens -= 3
      @p1_score = 0
      @p2_score = 0
      counter = 0
      p1_start_strength = player_1.cat.strength 
      p2_start_strength = player_2.cat.strength
      player_1.cat.strength = player_1.cat.strength * player_1.cat.move_luck 
      player_2.cat.strength = player_2.cat.strength * player_2.cat.move_luck
      puts "The best out of 6 rounds wins the competition!"
      while counter < 6 do
        competition_logic(player_1, player_2)
        puts "#{player_1.cat.name}'s energy is at #{player_1.cat.energy}"
        puts "#{player_2.cat.name}'s energy is at #{player_2.cat.energy}"
        if player_1.cat.energy < player_2.cat.energy
          @p2_score += 1
        else player_2.cat.energy < player_1.cat.energy
          @p1_score += 1
        end
        counter += 1
      end
      if @p1_score > @p2_score
        puts "#{player_1.cat.name} wins the competition!"
        puts "You earn 1 competition win, 3 tokens & 500 pawz!"
        player_1.competition_wins += 1
        player_2.losses += 1
        player_1.tokens += 3
        player_1.pawz += 500
        player_1.cat.energy = 100 # resets energy and strength
        player_2.cat.energy = 100
        player_1.cat.strength = p1_start_strength
        player_2.cat.strength = p1_start_strength
      elsif @p2_score > @p1_score
        puts "#{player_2.cat.name} wins the competition!"
        puts "You earn 1 competition win, 3 tokens & 500 pawz!"
        player_2.competition_wins += 1
        player_1.losses += 1
        player_1.tokens += 3
        player_2.pawz += 500
        player_1.cat.energy = 100
        player_2.cat.energy = 100
        player_1.cat.strength = p1_start_strength
        player_2.cat.strength = p1_start_strength
      else
        puts "#{player_1.cat.name} and #{player_2.cat.name} have both tied!"
        puts "Both earn 1 competition win, 3 tokens & 500 pawz!"
        player_1.competition_wins += 1
        player_2.competition_wins += 1
        player_1.pawz += 500
        player_2.pawz += 500
        player_1.tokens += 3
        player_2.tokens += 3
        player_1.cat.energy = 100
        player_2.cat.energy = 100
        player_1.cat.strength = p1_start_strength
        player_2.cat.strength = p1_start_strength
      end
    end
  end
end