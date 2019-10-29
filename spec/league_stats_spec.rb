require "./lib/stat_tracker"

RSpec.describe StatTracker do
  let (:stat_tracker) { build_stat_tracker }

  describe "#count_of_teams" do
    it "counts the total number of teams" do
      expect(stat_tracker.count_of_teams).to eq 32
    end
  end

  describe "#best_offense" do
    it "returns the name of the team with highest average score" do
      expect(stat_tracker.best_offense).to eq "FC Dallas"
    end
  end

  describe "#worst_offense" do
    it "returns the name of the team with the lowest average score" do
      expect(stat_tracker.worst_offense).to eq "Atlanta United"
    end
  end

  describe "#best_defense" do
    it "returns the name of the team with the lowest average allowed goals" do
      expect(stat_tracker.best_defense).to eq "Atlanta United"
    end
  end

  describe "#worst_defense" do
    it "returns the name of the team with the highest average allowed goals" do
      expect(stat_tracker.worst_defense).to eq "Houston Dynamo"
    end
  end

  describe "#highest_scoring_visitor" do
    it "returns the name of the team with the highest average visiting score" do
      expect(stat_tracker.highest_scoring_visitor).to eq "FC Dallas"
    end
  end

  describe "#lowest_scoring_home_team" do
    it "returns the name of the team with the lowest average home score" do
      expect(stat_tracker.lowest_scoring_home_team).to eq "Atlanta United"
    end
  end

  describe "#winningest_team" do
    it "returns the name of the team with the highest win percentage" do
      expect(stat_tracker.winningest_team).to eq "FC Dallas"
    end
  end

  describe "#best_fans" do
    it "returns the name of the team with the greatest difference between " +
      "home and away records" do
      expect(stat_tracker.best_fans).to eq "LA Galaxy"
    end
  end

  describe "#worst_fans" do
    it "lists the names of teams with better away records than home records" do
      expect(stat_tracker.worst_fans).to eq ["FC Dallas"]
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
