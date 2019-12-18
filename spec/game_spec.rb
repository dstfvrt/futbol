require "./lib/game"

RSpec.describe Game do
  let(:game) { build_game }

  let(:raw_attributes) do
    {
      game_id: "2012030221",
      season: "20122013",
      type: "Postseason",
      date_time: "5/16/13",
      away_team_id: "3",
      home_team_id: "6",
      away_goals: "2",
      home_goals: "3",
      venue: "Toyota Stadium",
      venue_link: "/api/v1/venues/null",
    }
  end

  describe "#initialize" do
    it "takes a hash and contains values" do
      expect(game.id).to eq 2012030221
      expect(game.season).to eq "20122013"
      expect(game.type).to eq "Postseason"
      expect(game.date_time).to eq "5/16/13"
      expect(game.away_team_id).to eq 3
      expect(game.home_team_id).to eq 6
      expect(game.away_goals).to eq 2
      expect(game.home_goals).to eq 3
      expect(game.venue).to eq "Toyota Stadium"
      expect(game.venue_link).to eq "/api/v1/venues/null"
    end

    describe "#away_win" do
      it "returns if the game was a away win" do
        expect(game.away_win?).to eq false
      end
    end

    describe "#has_team?" do
      it "returns if the game has a team id" do
        expect(game.has_team?(game.away_team_id)).to eq true
      end
    end

    describe "#home_win?" do
      it "returns if the game was a home win" do
        expect(game.home_win?).to eq true
      end
    end

    describe "#losing_team_id" do
      it "returns the team id that lost" do
        expect(game.losing_team_id).to eq 3
      end
    end

    describe "#score_difference" do
      it "gets the difference between the home goals and away goals" do
        expect(game.score_difference).to eq 1
      end
    end

    describe "#season_type" do
      it "returns the types of seasons as symbols" do
        expect(game.season_type).to eq :post_season
      end
    end

    describe "#tie" do
      it "returns if the game was a tie" do
        expect(game.tie?).to eq false
      end
    end

    describe "#total_score" do
      it "gets total goals of game" do
        expect(game.total_score).to eq 5
      end
    end

    describe "#winner?" do
      context "when the team is a part of the game" do
        it "returns true if the team won the game, false if the team lost" do
          losing_team = double("Team", id: 3)
          winning_team = double("Team", id: 6)

          expect(game.winner?(losing_team)).to eq false
          expect(game.winner?(winning_team)).to eq true
        end
      end

      context "when the team is not a part of the game" do
        it "returns false" do
          nonexistent_team = double("Team", id: 0)

          expect(game.winner?(nonexistent_team)).to eq false
        end
      end
    end

    describe "#winning_team_id" do
      it "returns the team id that won" do
        expect(game.winning_team_id).to eq 6
      end
    end
  end

  private

  def build_game
    Game.new(raw_attributes)
  end
end
