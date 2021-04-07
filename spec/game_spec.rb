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
    context "default game" do
      it "outputs all blank line for secret word, and outputs the incorrect moves remaining" do
        @game = Game.new
        @secret_word = @game.secret_word
        expect {@game.display_game_state}
          .to output("Word: >#{("_"*@secret_word.length).split("").join(" ")}\n" \
                     "Incorrect guesses remaining: 6\n").to_stdout
      end
    end
  end
end
