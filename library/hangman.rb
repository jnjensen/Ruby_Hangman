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

def choose_word()
    choosen = false

    until choosen
        word = $WORD_LIST.shuffle
        word = word[0]
        
        if word.length >= 5 && word.length <= 12
            choosen = true
        end
    end

    return word    
end

puts choose_word