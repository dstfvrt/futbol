require "stat_tracker"

RSpec.describe StatTracker do
  let (:stat_tracker) { build_stat_tracker }

  describe "#team_info" do
    it "returns a hash with team info" do
      team = [
        instance_double(Team, {
          id: 1,
          franchise_id: 23,
          name: "Team",
          abbreviation: "tm",
          link: "link",
        }),
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
      team_hash = {
        20122013 => 2,
        20132014 => 1,
      }

      teams = [
        instance_double(Team, {
          id: united_id,
          number_of_wins_by_season: team_hash,
        }),
        instance_double(Team, id: fire_id),
      ]

      allow(stat_tracker)
        .to receive(:teams)
        .and_return(teams)

      expect(stat_tracker.best_season(united_id)).to eq(20122013)
    end
  end

  describe "#worst_season" do
    it "returns season with the lowest win percentage for a team" do
      united_id = 1
      fire_id = 2
      team_hash = {
        20122013 => 2,
        20132014 => 1,
      }

      teams = [
        instance_double(Team, {
          id: united_id,
          number_lost_by_season: team_hash,
        }),
        instance_double(Team, id: fire_id),
      ]

      allow(stat_tracker)
        .to receive(:teams)
        .and_return(teams)

      expect(stat_tracker.worst_season(united_id)).to eq(20122013)
    end
  end

  describe "#average_win_percentage" do
    it "returns average win percentage of all games for a team" do
      united_id = 1
      fire_id = 2

      teams = [
        instance_double(Team, {
          id: united_id,
          number_of_wins: 3,
          games: 5,
        }),
        instance_double(Team, id: fire_id),
      ]

      allow(stat_tracker)
        .to receive(:teams)
        .and_return(teams)

      expect(stat_tracker.average_win_percentage(united_id)).to eq(60.00)
    end
  end
end
