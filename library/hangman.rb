require "csv"

puts "Let's Play Hangman!"

$WORD_LIST = File.readlines "5desk.txt"

class Player
    attr_reader :name
    attr_accessor :score
  
    def initialize(name, score = [0, 0])
      @name = name
      @score = score
    end
end

class GameBoard
    attr_reader :name
    attr_accessor :score

    @@blank_hangman = [
        "     _______     ", 
        "     |      |    ", 
        "            |    ", 
        "            |    ", 
        "            |    ", 
        "            |    ", 
        "            |    ", 
        "     -----------    "
    ]

    @@hangman_steps = [
        "    (       |    ", 
        "    ( )     |    ", 
        "     |      |    ", 
        "     |      |    ", 
        "    /|      |    ", 
        "    /|\     |    ", 
        "    /       |    ", 
        "    / \     |    "
    ]
      
    def initialize(word, guess = [], turn = 0, hangman = @@blank_hangman)
      @word = word
      @guess = guess
      @turn = turn
      @hangman = hangman
    end

    def create_wordblanks(word)
        array = []
        word.length.times { array << "__"}
        return array
    end
  
    def display_board
        array = create_wordblanks(@word)
        turn_left = (8 - @turn)
        if turn_left > 1
            puts "You have #{turn_left} turn left."
        else
            puts "You have #{turn_left} turns left."
        end

        puts " "
        puts @hangman
        puts " "
        puts (array.join(" "))

        puts "Letters you have guessed: #{@guess}"
    end 
end

def choose_word()
    choosen = false

    until choosen
        word = $WORD_LIST.shuffle
        word = word[0]
        word = word[0..(word.length-3)]
        
        if word.length >= 5 && word.length <= 12
            choosen = true
        end
    end

    return word    
end

def play_game
    new_game = GameBoard.new(choose_word)
    new_game.display_board
end

play_game