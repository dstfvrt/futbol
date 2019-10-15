require "stat_tracker"

RSpec.describe StatTracker do
  let (:stat_tracker) { build_stat_tracker }

  describe "#highest_total_score" do
    it "returns the highest sum of the winning and losing teams scores" do
      games = [
        instance_double(Game, total_score: 1),
        instance_double(Game, total_score: 5),
        instance_double(Game, total_score: 20),
        instance_double(Game, total_score: 10),
      ]

      allow(stat_tracker.games)
        .to receive(:records)
        .and_return(games)

      expect(stat_tracker.highest_total_score).to eq(20)
    end
  end

  describe "#lowest_total_score" do
    it "returns the lowest sum of the winning and losing teams scores" do
      games = [
        instance_double(Game, total_score: 1),
        instance_double(Game, total_score: 5),
        instance_double(Game, total_score: 20),
        instance_double(Game, total_score: 10),
      ]

      allow(stat_tracker.games)
        .to receive(:records)
        .and_return(games)

      expect(stat_tracker.lowest_total_score).to eq(1)
    end
  end

  describe "#biggest_blowout" do
    it "returns the highest difference between winner and loser" do
      games = [
        instance_double(Game, score_difference: 1),
        instance_double(Game, score_difference: 5),
        instance_double(Game, score_difference: 2),
        instance_double(Game, score_difference: 3),
      ]

      allow(stat_tracker.games)
        .to receive(:records)
        .and_return(games)

      expect(stat_tracker.biggest_blowout).to eq(5)
    end
  end

  describe "#percentage_home_wins" do
    it "returns percentage of games that a home team has won" do
      games = [
        instance_double(Game, home_win?: true),
        instance_double(Game, home_win?: true),
        instance_double(Game, home_win?: false),
      ]

      allow(stat_tracker.games)
        .to receive(:records)
        .and_return(games)

      expect(stat_tracker.percentage_home_wins).to eq(66.667)
    end
  end

  describe "#percentage_visitor_wins" do
    it "returns percentage of games that a visitor has won" do
      expect(stat_tracker.percentage_visitor_wins).to eq(26.316)
    end
  end

  describe "#percentage_ties" do
    it "returns percentage of games that has resulted in a tie" do
      expect(stat_tracker.percentage_ties).to eq(5.263)
    end
  end

  # describe "#count_of_games_by_season" do
  #   it "returns hash with season names as keys and counts of games as values" do
  #     expect(stat_tracker.count_of_games_by_season).to be_kind_of Hash
  #     expect(stat_tracker.count_of_games_by_season.keys)
  #   end
  # end

  describe "#average_goals_per_game" do
    xit "returns average number of goals scored in a game across all seasons" do
      expect(stat_tracker.average_goals_per_game).to eq(3.684)
    end
  end

  # describe "#average_goals_by_season" do
  #   it "returns a has with average number of goals scored in a game " do
  #     expect(stat_tracker.highest_total_score).to be_kind_of Hash
  #   end
  # end
end
