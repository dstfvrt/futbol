require "./lib/team"

RSpec.describe Team do
  let(:raw_attributes) do
    {
      team_id: "1",
      franchiseId: "23",
      teamName: "Atlanta United",
      abbreviation: "ATL",
      Stadium: "Mercedes-Benz Stadium",
      link: "/api/v1/teams/1",
    }
  end

  describe "#initialize" do
    it "takes a hash and contains values" do
      team = build_team
      expect(team.id).to eq 1
      expect(team.franchise_id).to eq 23
      expect(team.name).to eq "Atlanta United"
      expect(team.abbreviation).to eq "ATL"
      expect(team.stadium).to eq "Mercedes-Benz Stadium"
      expect(team.link).to eq "/api/v1/teams/1"
    end
  end

  def build_team
    Team.new(raw_attributes)
  end
end
