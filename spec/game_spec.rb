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
        @game.letters_guessed.push(@game.secret_word.chars.sample)
        @game.guesses_remaining = 3

        # masked word with currently guessed unmasked
        expect($stdout).to receive(:puts)
          .with("Word: >" + @game.secret_word.chars
          .map { |char| @game.letters_guessed.include?(char) ? char : "_" }
          .join(" "))
        
        # the letters that are guessed
        expect($stdout).to receive(:puts)
          .with("Letters guessed: >#{@game.letters_guessed.join(" ")}")

        # the amount of incorrect guesses remaining
        expect($stdout).to receive(:puts)
          .with("Incorrect guesses remaining: 3")

        # call display game state method
        @game.display_game_state
      end
    end
  end

  describe "#get_guess" do
    before(:context) do
      @game = Game.new
    end

    context "correct guess format first try" do
      it "returns guess as a lowercase letter" do
        allow($stdin).to receive(:gets).and_return("a")
        expect(@game.get_guess).to eq("a")
      end
    end
    
    context "correct guess format first try upper case" do
      it "returns guess as a lowercase letter" do
        allow($stdin).to receive(:gets).and_return("A")
        expect(@game.get_guess).to eq("a")
      end
    end
    
    context "incorrect guess format first try, correct second try" do
      it "returns guess as a lowercase letter" do
        allow($stdin).to receive(:gets).and_return("8", "a")
        expect(@game.get_guess).to eq("a")
      end
    end
  end

  describe "#make_guess" do
    before(:context) do
      @game = Game.new
      @original_remaining = @game.guesses_remaining
    end

    context "correct guess" do
      before(:all) do
        @game.secret_word = "house"
      end

      it "guesses remaining doesn't change" do
        allow($stdin).to receive(:gets).and_return("h")
        @game.make_guess

        expect(@game.guesses_remaining).to eq(original_remaining)
      end

      it "letter added to letters_guessed" do
        allow($stdin).to receive(:gets).and_return("h")
        @game.make_guess

        expect(@game.letters_guessed.length).to eq(1)
      end
    end
  end
end
