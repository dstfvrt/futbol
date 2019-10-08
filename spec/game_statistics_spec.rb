require "stat_tracker"

RSpec.describe StatTracker do
  describe "#highest_total_score" do
    it "returns the highest sum of the winning and losing teams scores" do
      stat_tracker = StatTracker.new
      expect(stat_tracker.highest_total_score).to eq()
    end
  end
  describe "#lowest_total_score" do
    it "returns the lowest sum of the winning and losing teams scores" do
      stat_tracker = StatTracker.new
      expect(stat_tracker.highest_total_score).to eq()
    end
  end
  describe "#biggest_blowout" do
    it "returns the highest difference between winner and loser" do
      stat_tracker = StatTracker.new
      expect(stat_tracker.highest_total_score).to eq()
    end
  end
  describe "#percentage_home_wins" do
    it "returns percentage of games that a home team has won" do
      stat_tracker = StatTracker.new
      expect(stat_tracker.highest_total_score).to eq()
    end
  end
  describe "#percentage_visitor_wins" do
    it "returns percentage of games that a visitor has won" do
      stat_tracker = StatTracker.new
      expect(stat_tracker.highest_total_score).to eq()
    end
  end
  describe "#percentage_ties" do
    it "returns percentage of games that has resulted in a tie" do
      stat_tracker = StatTracker.new
      expect(stat_tracker.highest_total_score).to eq()
    end
  end
  describe "#count_of_games_by_season" do
    it "returns hash with season names as keys and counts of games as values" do
      stat_tracker = StatTracker.new
      expect(stat_tracker.highest_total_score).to eq()
    end
  end
  describe "#average_goals_per_game" do
    it "returns average number of goals scored in a game across all seasons" do
      stat_tracker = StatTracker.new
      expect(stat_tracker.highest_total_score).to eq()
    end
  end
  describe "#average_goals_by_season" do
    it "returns a has with average number of goals scored in a game " do
      stat_tracker = StatTracker.new
      expect(stat_tracker.highest_total_score).to eq()
    end
  end
end
