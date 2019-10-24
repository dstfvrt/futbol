require "stat_tracker"

RSpec.describe StatTracker do
  let (:stat_tracker) { build_stat_tracker }

  describe "#team_info" do
    it "returns a hash with team info" do
      team = [
        instance_double(Team, team_id: 1, franchise_id: 23, team_name: "Team",
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
      team = [
        instance_double(Team, team_id: 1, franchise_id: 23, team_name: "Team",
        abbreviation: "tm", link: "link"),
      ]

      allow(stat_tracker)
        .to receive(:teams)
        .and_return(team)


      expect(stat_tracker.highest_win_percentage(1)).to eq(team_hash)
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
