require "./lib/team"

RSpec.describe Team do
  raw_attributes = {
    team_id: "1",
    franchiseId: "23",
    teamName: "Atlanta United",
    abbreviation: "ATL",
    Stadium: "Mercedes-Benz Stadium",
    link: "/api/v1/teams/1",
  }

  describe "#initialize" do
    it "takes a hash and contains values" do
      team = Team.new(raw_attributes)
      expect(team.team_id).to eq 1
      expect(team.franchise_id).to eq 23
      expect(team.team_name).to eq "Atlanta United"
      expect(team.abbreviation).to eq "ATL"
      expect(team.stadium).to eq "Mercedes-Benz Stadium"
      expect(team.link).to eq "/api/v1/teams/1"
    end
  end
end
