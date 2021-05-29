class Game
  def self.quiz_run(player_1, player_2)
    if player_1.tokens < 1 
      puts "#{player_1.user.email}: You need to earn more tokens!"
    else
      player_1.tokens -= 1
      player_2.tokens -= 1
      puts "Welcome to University of Cats CAT101 exam!"
      puts "Meow, here is 10 feline questions."
      puts "The cat to get the most points wins!"

      puts "Player 1 up first! (psssss player 2 don't look please!)"
      p1_score = quiz(player_1)
      puts "#{player_1.user.email} scored #{p1_score} out of 10"
      puts "Next up, Player 2!!!"
      if player_2.user.email == "Computer"
        puts "You are playing against a computer."
        p2_score = rand(0..8)
        puts "The computer scored #{p2_score} out of 10!"
      else
        p2_score = quiz(player_2)
        puts "#{player_2.user.email} scored #{p2_score}"
      end
      if p1_score > p2_score
        winner_is?(p1=true, p2=false, player_1, player_2)
      elsif p2_score > p1_score
        winner_is?(p1=false, p2=true, player_1, player_2)
      else
        winner_is?(p1=true, p2=true, player_1, player_2)
      end
    end
  end

  def self.quiz
    @score = 0

    # The questions
    q1 = ["Cats can sweat through their paws: true or false?\n\tA) true\t\tB) false", 'a',"The correct answer is a! Cats sweat out of paws"]
    q2 = ["What is a name of a group of cats?\n\tA) School B) Shoaling C) Clowder D) Walering", 'c', "The correct answer is clowder. Also, known as 'glaring'!"]
    q3 = ["Toxoplasmosis is a parasitic disease that is transmittable through feline sexual reproduction:\n\tt for True/f for False?", 't', "The correct answer is true!"]  
    q4 = ["Fill in the blank: Denmark, 1995 -- the ___ Cat was born. The cat has been extensively researched, yet with no solid conclusion for it's unique trait:\n\tA) screaming B) tallest C) oldest D) Green", 'd', "The correct answer is Green."]
    q5 = ["How many bones do cats have?\n\tA)300 B)230 C)145 D)206", 'b', "Cats have 230 bones, a whopping 24 more bones than humans!"]
    q6 = ["What is the name of a group of kittens?\n\tA) kindle B) krowder C) pawter D) Shoaling", 'a', "A group of kittens is called a 'kindle'."]
    q7 = ["Do indoor cats live longer than outdoor cats?\n\tt for True/f for False?", 't', "According to research indoor cats have a longer life span on average"]
    q8 = ["On average, how many whiskers does a cat have on ONE side of its face?\n\tA) 8 B) 9 C) 14 D)12", 'd',"There are roughly 24 whiskers, 12 on each side, on a cats face"]
    q9 = ["On average, how many kittens does a mother have in one litter?\n\tA)1-2 B)2-3 C)3-4 D)6", 'b', "A mother cat usually gives birth to 2-3 per litter, and can have approx. 2 litters per year!"]
    q10 = ["As the end of 2021, how old is the comic Garfield?\n\tA) 29 B) 35 C)43 D) 31", 'c', "Garfield launched on June 19, 1978 - making it 43 years old as of June!"]

    # Questions in array
    questions = [q1, q2, q3, q4, q5, q6, q7, q8, q9, q10]

    # Iterate over questions in array: For each, print 0th element, ask and compare input to 1st element. If correct add 1 to score.
    for question in questions
      puts question[0]
      answer = gets.chomp.downcase
      puts question[2]
      if answer == question[1]
        puts "You are correct!"
        @score += 1
      else
        puts "Better luck next time."
      end
    end
    @score
  end
end

