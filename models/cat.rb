# I hope you are a cat person... or atleast appeciate a cute one because this game is all about cats!
# Cats act as your companions in Competition Cats. Each cat uniquely have both strengths and weaknesses.
# Each cat should have a name, size, confidence, agility, and strength. These traits effect gameplay.
# Cats are entered into competitions against mutliple human players and/or computer opponents.
# Results of competitions are reflected through wins, looses, ties, and competition wins
class Cat
  attr_accessor :wins, :losses, :energy, :name, :strength, :size, :agility, :confidence, :luck

  def initialize(name, size, energy, confidence, agility, strength)
    @name = name
    @size = ['small', 'medium', 'large'].sample
    @energy = 100
    @confidence = starter_confidence
    @agility = starter_agility
    @strength = starter_strength
  end

  # Saves template starter cats
  def save
    File.open('./data/cats', 'a') do |file|
      file.write("#{@name}, #{@size}, #{energy}, #{confidence}, #{agility}, #{strength}\n")
    end
  end

  # Loads starter cats
  def self.load 
    cats = []
    File.open('./data/cats', 'r') do |file|
      file.each_line do |line|
        name, size, energy, confidence, agility, strength = line.split(", ")
        cats << Cat.new(name, size, energy, confidence, agility, strength.chomp)
      end
    end
    cats
  end

  # Starter agility determined by size of cat
  def starter_agility
    base = 50
    case size
    when 'small'
      bonus = 25
    when 'medium'
      bonus = 10
    when 'large'
      bonus = 0
    end
    @agility = base + bonus
  end

  # Starter strength determined by size of cat
  def starter_strength
    base = 50
    case size
    when 'large'
      bonus = 25
    when 'medium'
      bonus = 10
    when 'small'
      bonus = 0
    end
    @strength = base + bonus
  end

  # Starter confidence
  def starter_confidence
    50 
  end

  # Competition luck component
  def move_luck
    @luck = rand(1..6)
  end

  def add_str
    @strength += 5
  end

  def add_agility
    @agility += 5
  end

  def add_confidence
    @confidence += 5
  end

  # To string
  def to_s
    "name: #{@name}, size: #{@size}, energy: #{@energy}, agility: #{@agility}, strength: #{@strength}, confidence: #{@confidence}"
  end
end
