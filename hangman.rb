require_relative 'lib/game'

# enable garbage collection for the program
GC.enable

def clear
  system("clear") || system("cls")
end

# Uncomment the lines relating to memory to have debug output at end of program for memory
# memory = []

word_file = File.open("word_list.txt", "r")
word_list = word_file.read.split("\n")
word_list.select! { |word| (5..12).include?(word.length) }
word_file.close

# game loop
loop do
  clear
  
  # memory.push(ObjectSpace.each_object(Object).count)

  puts "Options:"
  puts ""
  puts "1. Load save game."
  puts "2. Start new game."
  puts "3. Quit game."
  puts

  print ">"
  choice = $stdin.gets.chomp.downcase
  until choice.match(/1|2|3|save|new|quit/)
    puts "Please enter a valid choice"
    puts "Choices: (1/2/3/load/new/quit)"
    print ">"
    choice = $stdin.gets.chomp.downcase
  end

  case choice
  when "1", "load"
    saves = Dir["./saves/*"]

    if saves == []
      puts "You have no saves to load."
      puts
      puts "Press enter to continue"

      $stdin.gets

      next
    else
      names = []
      
      saves.each do |save|
        names.push(save.scan(/(.\/saves\/)(.*)(.json)/)[0][1])
      end

      clear

      # prints each name on a new line with name number
      puts "Saves:"
      names.each_with_index { |name, index| puts "#{index + 1}. #{name}" }

      puts
      puts "What is the save name/number?"
      save = $stdin.gets.chomp.downcase
      until save.match(/[1-#{names.length}]/) || names.include?(save)
        save = $stdin.gets.chomp.downcase
      end
      
      if save.match(/[[:digit:]]/)
        save = names[(save.to_i) - 1]
      end

      save_file = File.open("./saves/" + save + ".json", "r")
      loaded = JSON.parse(save_file.read)
      save_file.close

      clear

      game = Game.new
      game.guesses_remaining = loaded["guesses_remaining"]
      game.secret_word = loaded["secret_word"]
      game.letters_guessed = loaded["letters_guessed"]
      game.play

      puts
      puts "Press enter to continue."
      $stdin.gets
    end
  when "2", "new"
    clear

    puts "Max amount of guesses (press Enter for default of 6):"
    print ">"
    amount = $stdin.gets.chomp
    until (amount.match(/\A\d+\z/) && (amount.to_i) > 0) || amount == ""
      puts "Please enter a positive number."
      puts
      print ">"
      amount = $stdin.gets.chomp
    end

    guesses = amount == "" ? 6 : amount.to_i

    game = Game.new(guesses, game_word_list = word_list)
    game.play

    puts
    puts "Press enter to continue."
    $stdin.gets
  when "3", "quit"
    break
  end

  # garbage collection
  GC.start

end

# puts memory
