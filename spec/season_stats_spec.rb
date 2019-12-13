require "./lib/stat_tracker"

RSpec.describe StatTracker do
  let (:stat_tracker) { build_stat_tracker }

  describe "#biggest_bust" do
    it "returns the name of the team with the biggest decrease between " +
      "regular season and postseason win percentage" do
      expect(stat_tracker.biggest_bust("20122013")).to eq "FC Dallas"
    end
  end

  describe "#biggest_surprise" do
    it "returns the name of the team with the biggest increase between " +
      "regular season and postseason win percentage" do
      expect(stat_tracker.biggest_surprise("20122013")).to eq "Sporting" +
        " Kansas City"
    end
  end

  describe "#winningest_coach" do
    it "returns the name of the coach of the team with the highest win" +
      "percentage" do
      expect(stat_tracker.winningest_coach("20122013")).to eq "Claude Julien"
    end
  end

  describe "#worst_coach" do
    it "returns the name of the coach of the team with the lowest win" +
      "percentage" do
      expect(stat_tracker.worst_coach("20122013")).to eq "John Tortorella"
    end
  end

  describe "#most_accurate_team" do
    it "returns the name of the team with the best ratio of shots to goals" +
      " for the season" do
      expect(stat_tracker.most_accurate_team("20122013")).to eq "FC Dallas"
    end
  end

  describe "#least_accurate_team" do
    it "returns the name of the team with the worst ratio of shots to goals" +
      " for the season" do
      expect(stat_tracker.least_accurate_team("20122013")).to eq "Sporting" +
        " Kansas City"
    end
  end

  describe "#most_tackles" do
    it "returns the name of the team with the most tackles in the season" do
      expect(stat_tracker.most_tackles("20122013")).to eq "FC Dallas"
    end
  end

  describe "#fewest_tackles" do
    it "returns the name of the team with the fewest tackles in the season" do
      expect(stat_tracker.fewest_tackles("20122013")).to eq "FC Dallas"
    end
  end

  private

  def build_stat_tracker
    filepaths = {
      games: "./spec/fixtures/games.csv",
      teams: "./spec/fixtures/teams.csv",
      gameteams: "./spec/fixtures/game_teams.csv",
    }

    StatTracker.new(filepaths)
  end
end
