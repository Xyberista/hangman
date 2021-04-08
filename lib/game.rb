require 'json'

class Game
  attr_accessor :secret_word, :guesses_remaining, :letters_guessed

  def initialize(max_guesses = 6)
    word_file = File.open("5desk.txt", "r")
    word_list = word_file.read.split("\n")
    word_list.select! { |word| (5..12).include?(word.length) }
    word_file.close

    @secret_word = word_list.sample
    @guesses_remaining = max_guesses
    @letters_guessed = []
  end

  def display_game_state
    masked_word = 
      secret_word.chars
        .map { |char| letters_guessed.include?(char) ? char : "_" }
        .join(" ")

    puts "Word: >" + masked_word
    puts "Letters guessed: >" + letters_guessed.join(" ")
    puts "Incorrect guesses remaining: #{guesses_remaining}"
  end

  def get_guess
    puts "Enter a letter to guess, and the word 'save' to save the game"
    print ">"
    guess = $stdin.gets.chomp
    until guess.scan(/[a-zA-Z]/).length == 1 && !@letters_guessed.include?(guess)
      break if guess.match(/save/)
      if @letters_guessed.include?(guess)
        puts "Please enter a new letter"
      else
        puts "Please enter a letter."
      end
      print ">"
      guess = $stdin.gets.chomp
    end
    guess.downcase
  end

  def make_guess
    guess = get_guess

    if guess != "save"
      unless @secret_word.include?(guess)
        @guesses_remaining -= 1
      end

      @letters_guessed.push(guess)
      return 0
    else
      return 1
    end
  end

  def json_info
    data = {
      secret_word: @secret_word,
      guesses_remaining: @guesses_remaining,
      letters_guessed: @letters_guessed
    }
  end

  def play
    game_won = false
    until game_won || @guesses_remaining == 0
      display_game_state
      choice = make_guess
      if choice == 1
        puts "Enter save name:"
        print ">"
        save_name = gets.chomp

        Dir.mkdir("saves") unless File.directory?("saves")

        if File.exists?("./saves/" + save_name + ".json")
          puts "#{save_name} already exists. Would you like to replace it? (y/n)"
          print ">"
          replace = gets.chomp
          until replace.match(/(y|n)/)
            puts "Please enter 'y' or 'n'"
            print ">"
            replace = gets.chomp
          end

          save_name = "./saves/" + save_name + ".json"

          if replace == "y"
            save_file = File.open(save_name, "w")
            save_file.write(JSON.pretty_generate(self.json_info))
            save_file.close
          else
            redo
          end
        else
          save_name = "./saves/" + save_name + ".json"
          save_file = File.new(save_name, "w")
          save_file.write(JSON.pretty_generate(self.json_info))
          save_file.close
        end

        break
      end
    end
    
    return if choice == 1

    if game_won
      puts "Congratulations! You won!"
    else
      puts "Sorry, you did not guess the word. The correct word was: #{@secret_word}"
    end
  end
end
