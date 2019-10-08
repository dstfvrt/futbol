require "stat_tracker"

RSpec.describe StatTracker do
  describe "#initialize" do
    it "creates repositories for Team, Game, and GameTeam records" do
      stat_tracker = StatTracker.new

      expect(stat_tracker.games).to be_kind_of Repository
      expect(stat_tracker.games.records.first).to be_kind_of Game
      expect(stat_tracker.teams).to be_kind_of Repository
      expect(stat_tracker.teams.records.first).to be_kind_of Team
      expect(stat_tracker.game_teams).to be_kind_of Repository
      expect(stat_tracker.game_teams.records.first).to be_kind_of GameTeam
    end
  end
end
