require "./lib/stat_tracker"

RSpec.describe StatTracker do
  let (:stat_tracker) { StatTracker.new }

  describe "count_of_teams" do
    it "counts the total number of teams" do
      expect(stat_tracker.count_of_teams).to eq 32
    end
  end

  describe "best_offense" do
    it "returns name of team with highest average score" do
      expect(stat_tracker.best_offense).to eq ""
    end
end
