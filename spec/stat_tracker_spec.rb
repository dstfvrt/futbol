require "./lib/stat_tracker"

RSpec.describe StatTracker do
  let (:stat_tracker) { build_stat_tracker }
  describe "#initialize" do
    it "creates repositories for Team, Game, and GameTeam records" do
      expect(stat_tracker.games).to be_kind_of Repository
      expect(stat_tracker.games.records.first).to be_kind_of Game
      expect(stat_tracker.teams).to be_kind_of Repository
      expect(stat_tracker.teams.records.first).to be_kind_of Team
      expect(stat_tracker.game_teams).to be_kind_of Repository
      expect(stat_tracker.game_teams.records.first).to be_kind_of GameTeam
    end
  end

  private

  def build_stat_tracker
    filepaths = Hash.new
    filepaths[:games] = "./spec/fixtures/games.csv"
    filepaths[:teams] = "./spec/fixtures/teams.csv"
    filepaths[:gameteams] = "./spec/fixtures/game_teams.csv"

    StatTracker.new(filepaths)
  end
end
