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
    puts "What is your guess?"
    print ">"
    guess = $stdin.gets.chomp
    until guess.scan(/[a-zA-Z]/).length == 1 && !@letters_guessed.include?(guess)
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

    unless @secret_word.include?(guess)
      @guesses_remaining -= 1
    end

    @letters_guessed.push(guess)
  end

  def play
    game_won = false
    until game_won || @guesses_remaining == 0
      display_game_state
      make_guess
    end

    if game_won
      puts "Congratulations! You won!"
    else
      puts "Sorry, you did not guess the word. The correct word was: #{@secret_word}"
    end
  end
end
