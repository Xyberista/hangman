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
    puts "Choices: (1/2/save/new)"
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

      gets

      next
    else
    end
  when "2", "save"
    game = Game.new
    game.play
  when "3", "quit"
    break
  end
end
