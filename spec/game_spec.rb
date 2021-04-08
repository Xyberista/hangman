require 'game'

describe Game do
  describe "#initialize" do
    context "default settings" do
      before(:all) do
        @game = Game.new
      end

      it "a word between 5 and 12 characters is selected" do
        expect(@game.secret_word.length).to be >= 5 && be <= 12
      end

      it "the incorrect guesses remaining is by default set to 6" do
        expect(@game.guesses_remaining).to eq(6)
      end
    end

    context "custom configuration (10 guesses)" do
      before(:all) do
        @game = Game.new(10)
      end

      it "a word between 5 and 12 characters is selected" do
        expect(@game.secret_word.length).to be >= 5 && be <= 12
      end

      it "the incorrect guesses remaining is set to 10" do
        expect(@game.guesses_remaining).to eq(10)
      end
    end
  end

  describe "#display_game_state" do
    context "default start of game" do
      it "output masked word, letters guessed, and incorrect guesses remaining" do
        @game = Game.new

        # masked word with currently guessed unmasked
        expect($stdout).to receive(:puts)
          .with("Word: >#{("_"*@game.secret_word.length).split("").join(" ")}")
        
        # the letters that are guessed
        expect($stdout).to receive(:puts)
          .with("Letters guessed: >#{@game.letters_guessed.sort.join(" ")}")

        # the amount of incorrect guesses remaining
        expect($stdout).to receive(:puts)
          .with("Incorrect guesses remaining: 6")

        # call display game state method
        @game.display_game_state
      end
    end

    context "some letters already guessed" do
      it "some unmasked, letters guessed, and moves remaining." do
        @game = Game.new
        @game.letters_guessed = [@game.secret_word.chars.sample]

        # masked word with currently guessed unmasked
        expect($stdout).to receive(:puts)
          .with("Word: >" + @game.secret_word.chars
          .map { |char| @game.letters_guessed.include?(char) ? char : "_" }
          .join(" "))
        
        # the letters that are guessed
        expect($stdout).to receive(:puts)
          .with("Letters guessed: >#{@game.letters_guessed.sort.join(" ")}")

        # the amount of incorrect guesses remaining
        expect($stdout).to receive(:puts)
          .with("Incorrect guesses remaining: 6")

        # call display game state method
        @game.display_game_state
      end
    end
  end
end
