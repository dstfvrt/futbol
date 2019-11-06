require "./lib/stat_tracker"

RSpec.describe StatTracker do
  let (:stat_tracker) { build_stat_tracker }
  describe "#initialize" do
    it "creates repositories for Team, Game, and GameTeam records" do
      expect(stat_tracker.games_repo).to be_kind_of Repository
      expect(stat_tracker.games_repo.records.first).to be_kind_of Game
      expect(stat_tracker.teams_repo).to be_kind_of Repository
      expect(stat_tracker.teams_repo.records.first).to be_kind_of Team
      expect(stat_tracker.game_teams_repo).to be_kind_of Repository
      expect(stat_tracker.game_teams_repo.records.first).to be_kind_of GameTeam
    end
  end
end
