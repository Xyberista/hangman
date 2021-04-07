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
    puts "Incorrect guesses remaining: #{guesses_remaining}"
  end
end
