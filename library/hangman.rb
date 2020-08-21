require "csv"

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
    attr_reader :word

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
      
    def initialize(word, guess = [], turn = 0, hangman = @@blank_hangman, array = [])
      @word = word
      @guess = guess
      @turn = turn
      @hangman = hangman
      @array = array
    end

    def clearboard(word)
      @word = word
      @guess = []
      @turn = 0
      @hangman = @@blank_hangman
      @array = []
    end

    def create_wordblanks(word)
        array = []
        word.length.times { array << "__"}
        return array
    end
  
    def display_board
        turn_left = (8 - @turn)
        if turn_left > 1
            puts "You have #{turn_left} turn left."
        else
            puts "You have #{turn_left} turns left."
        end

        puts " "
        puts @hangman
        puts " "
        puts (@array.join(" "))
        puts " "
        puts "Letters you have guessed: #{@guess}"
        puts " "
    end 

    def change_hangman(incorrect)
        if incorrect  == 1 || incorrect == 2
            trade = 2
        elsif incorrect == 3
            trade = 3
        elsif incorrect == 4 || incorrect == 5 || incorrect == 6
            trade = 4
        elsif incorrect == 7 || incorrect == 8
            trade = 5
        end
        @hangman[trade] = @@hangman_steps[(incorrect-1)]
    end

    def change_letter(guess_letter)
        count = 0

        @array.each do
            letter1 = @word[count].downcase
            if letter1 == guess_letter
                @array[count] = @word[count]
            end
            count += 1
        end
    end
    
    def take_turn
        game_over = false
        incorrect = 0
        @array = create_wordblanks(@word)

        until game_over do
            display_board
            puts "What letter is your guess?"
            letter = gets.chomp.downcase
            puts " "
            if @guess.include?(letter) || @array.include?(letter)
                different = false
                until different do
                    puts "You've already guessed that letter."
                    puts "What other letter would you like to guess?"
                    letter = gets.chomp.downcase
                    puts " "
                    if !(@guess.include?(letter)) && !(@array.include?(letter))
                        different = true
                    end
                end
            end

            if (@word.downcase).include?(letter)
                change_letter(letter)
                if !(@array.include?("__"))
                    game_status = "win"
                    game_over = true
                end
            else
                incorrect += 1
                @turn += 1
                @guess << letter
                change_hangman(incorrect)
                if @turn == 8
                    game_status = "lose"
                    game_over = true
                end
            end
        end
        return game_status
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

def create_player
    puts "Hello, what is your name?"
    name = gets.chomp.downcase.capitalize
    puts " "
    player = Player.new(name)
    return player
end

def new_game
    clearboard(choose_word)
    puts "Let's play another round of hangman, #{player1.name}!"
    game = new_game.take_turn
    if game == "win"
        puts "Congrats, #{player1.name}, you won!"
        player1.score[0] += 1
    else
        puts new_game.hangman
        puts "Sorry, #{player1.name}, you lost!"
        puts "The word was: #{new_game.word}"
        player1.score[1] += 1
    end
    puts "Wins: #{player1.score[0]}"
    puts "Loses: #{player1.score[1]}"
    puts " "
    puts "Do you want to play another round? (Y/N)"
    answer = gets.chomp.downcase
    if answer == y
        new_game
    end
end

def play_game
    player1 = create_player
    new_game = GameBoard.new(choose_word)
    puts "Let's play hangman, #{player1.name}!"
    game = new_game.take_turn
    if game == "win"
        puts "Congrats, #{player1.name}, you won!"
        player1.score[0] += 1
    else
        puts "Sorry, #{player1.name}, you lost!"
        puts "The word was: #{new_game.word}"
        player1.score[1] += 1
    end
    puts "Wins: #{player1.score[0]}"
    puts "Loses: #{player1.score[1]}"
    puts " "
    puts "Do you want to play another round? (Y/N)"
    answer = gets.chomp.downcase
    if answer == "y"
        new_game
    end
end

play_game