require "stat_tracker"

RSpec.describe StatTracker do
  let (:stat_tracker) { build_stat_tracker }

  describe "#team_info" do
    it "returns a hash with team info" do
      team = [
        instance_double(Team, id: 1, franchise_id: 23, name: "Team",
        abbreviation: "tm", link: "link"),
      ]

      allow(stat_tracker)
        .to receive(:teams)
        .and_return(team)

      team_hash = {
        "team_id" => 1,
        "franchise_id" => 23,
        "team_name" => "Team",
        "abbreviation" => "tm",
        "link" => "link",
      }
      expect(stat_tracker.team_info(1)).to eq(team_hash)
    end
  end

  describe "#best_season" do
    it "returns season with the highest win percentage for a team" do
      united_id = 1
      fire_id = 2
      games = [
        instance_double(Game, {
          season: 20122013,
          home_team_id: united_id,
          away_team_id: fire_id,
          home_goals: 2,
          away_goals: 1,
        }),
        instance_double(Game, {
          season: 20122013,
          home_team_id: fire_id,
          away_team_id: united_id,
          home_goals: 1,
          away_goals: 2,
        }),
        instance_double(Game, {
          season: 20132014,
          home_team_id: united_id,
          away_team_id: fire_id,
          home_goals: 2,
          away_goals: 1,
        }),
        instance_double(Game, {
          season: 20132014,
          home_team_id: fire_id,
          away_team_id: united_id,
          home_goals: 2,
          away_goals: 1,
        }),
      ]
      allow(stat_tracker)
        .to receive(:games)
        .and_return(games)


      expect(stat_tracker.best_season(united_id)).to eq(20122013)
    end
  end

  describe "#worst_season" do
    it "returns season with the lowest win percentage for a team" do

    end
  end

  describe "#average_win_percentage" do
    it "returns average win percentage of all games for a team" do

    end
  end
end
