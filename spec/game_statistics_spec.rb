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

      allow(stat_tracker)
        .to receive(:games)
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

      allow(stat_tracker)
        .to receive(:games)
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

      allow(stat_tracker)
        .to receive(:games)
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

      allow(stat_tracker)
        .to receive(:games)
        .and_return(games)

      expect(stat_tracker.percentage_home_wins).to eq(66.667)
    end
  end

  describe "#percentage_visitor_wins" do
    it "returns percentage of games that a visitor has won" do
      games = [
        instance_double(Game, away_win?: true),
        instance_double(Game, away_win?: true),
        instance_double(Game, away_win?: false),
      ]

      allow(stat_tracker)
        .to receive(:games)
        .and_return(games)

      expect(stat_tracker.percentage_visitor_wins).to eq(66.667)
    end
  end

  describe "#percentage_ties" do
    it "returns percentage of games that has resulted in a tie" do
      games = [
        instance_double(Game, tie?: true),
        instance_double(Game, tie?: true),
        instance_double(Game, tie?: false),
      ]

      allow(stat_tracker)
        .to receive(:games)
        .and_return(games)

      expect(stat_tracker.percentage_ties).to eq(66.667)
    end
  end

  describe "#count_of_games_by_season" do
    it "returns hash with season names as keys and counts of games as values" do
      games = [
        instance_double(Game, season: 20122013),
        instance_double(Game, season: 20122013),
        instance_double(Game, season: 20132014),
        instance_double(Game, season: 20132014),
        instance_double(Game, season: 20132014),
        instance_double(Game, season: 20142015),
      ]

      allow(stat_tracker)
        .to receive(:games)
        .and_return(games)

      seasons_hash = {
        20122013 => 2,
        20132014 => 3,
        20142015 => 1,
      }
      expect(stat_tracker.count_of_games_by_season).to eq(seasons_hash)
    end
  end

  describe "#average_goals_per_game" do
    it "returns average number of goals scored in a game across all seasons" do
      games = [
        instance_double(Game, total_score: 1),
        instance_double(Game, total_score: 4),
        instance_double(Game, total_score: 3),
        instance_double(Game, total_score: 5),
        instance_double(Game, total_score: 5),
        instance_double(Game, total_score: 1),
      ]

      allow(stat_tracker)
        .to receive(:games)
        .and_return(games)

      expect(stat_tracker.average_goals_per_game).to eq(3.167)
    end
  end

  describe "#average_goals_by_season" do
    it "returns a hash with average number of goals scored in a game " do
      games = [
        instance_double(Game, season: 20122013, total_score: 2),
        instance_double(Game, season: 20122013, total_score: 1),
        instance_double(Game, season: 20122013, total_score: 5),
        instance_double(Game, season: 20132014, total_score: 1),
        instance_double(Game, season: 20132014, total_score: 4),
        instance_double(Game, season: 20142015, total_score: 3),
      ]

      allow(stat_tracker)
        .to receive(:games)
        .and_return(games)

      seasons_hash = {
        20122013 => 2.667,
        20132014 => 2.5,
        20142015 => 3,
      }
      expect(stat_tracker.average_goals_by_season).to eq(seasons_hash)
    end
  end
end
