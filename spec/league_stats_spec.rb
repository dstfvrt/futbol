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
      allow(stat_tracker.teams)
        .to receive(:records)
        .and_return(teams)

      allow(stat_tracker.games)
        .to receive(:records)
        .and_return(games)

      expect(stat_tracker.best_offense).to eq "two"
    end
  end

  describe "#worst_offense" do
    it "returns the name of the team with the lowest average score" do
      allow(stat_tracker.teams)
        .to receive(:records)
        .and_return(teams)

      allow(stat_tracker.games)
        .to receive(:records)
        .and_return(games)

      expect(stat_tracker.worst_offense).to eq "three"
    end
  end

  describe "#best_defense" do
    it "returns the name of the team with the lowest average allowed goals" do
      expect(stat_tracker.best_defense).to eq 0
    end
  end

  private

  def teams
    team_1 = Team.new(team_id: 1, teamName: "one")
    team_2 = Team.new(team_id: 2, teamName: "two")
    team_3 = Team.new(team_id: 3, teamName: "three")
    [team_1, team_2, team_3]
  end

  def games
      [
        instance_double(Game, {
          away_team_id: teams[0].team_id,
          away_goals: 3,
          home_team_id: 0,
          home_goals: 0
        }),
        instance_double(Game, {
          away_team_id: 0,
          away_goals: 0,
          home_team_id: teams[0].team_id,
          home_goals: 2
        }),
        instance_double(Game, {
          away_team_id: teams[1].team_id,
          away_goals: 4,
          home_team_id: 0,
          home_goals: 0
        }),
        instance_double(Game, {
          away_team_id: 0,
          away_goals: 0,
          home_team_id: teams[1].team_id,
          home_goals: 4
        }),
        instance_double(Game, {
          away_team_id: teams[2].team_id,
          away_goals: 1,
          home_team_id: 0,
          home_goals: 0
        }),
        instance_double(Game,{
          away_team_id: 0,
          away_goals: 0,
          home_team_id: teams[2].team_id,
          home_goals: 2
        }),
      ]
  end

  def build_stat_tracker
    filepaths = {
      games: "./spec/fixtures/games.csv",
      teams: "./spec/fixtures/teams.csv",
      gameteams: "./spec/fixtures/game_teams.csv"
    }

    StatTracker.new(filepaths)
  end
end
