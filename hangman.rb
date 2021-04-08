require_relative 'lib/game'

def clear
  system("clear") || system("cls")
end

# game loop
loop do
  clear
  puts "Options:"
  puts "1. Load save game."
  puts "2. Start new game."
  puts "3. Quit game"
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

    game = Game.new
    game.play

    puts
    puts "Press enter to continue."
    $stdin.gets
  when "3", "quit"
    break
  end
end
