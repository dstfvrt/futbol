require "stat_tracker"

RSpec.describe StatTracker do
  let (:stat_tracker) { build_stat_tracker }

  describe "#team_info" do
    it "returns a hash with team info" do
      teams = [
        instance_double(Team, team_id: 1, franchise_id: 23, team_name: "Team",
        abbreviation: "tm", link: "link"),
      ]

      allow(stat_tracker)
        .to receive(:teams)
        .and_return(teams)

      team_hash = {
        "team_id" => 1,
        "franchise_id" => 23,
        "team_name" => "Team",
        "abbreviation" => "tm",
        "link" => "link",
      }
      expect(stat_tracker.team_info).to eq(team_hash)
    end
  end
end
