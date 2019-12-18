require "./lib/team"
require "./lib/game"

RSpec.describe Team do
  let (:team) { build_team }

  let(:raw_attributes) do
    {
      team_id: "1",
      franchiseid: "23",
      teamname: "Atlanta United",
      abbreviation: "ATL",
      stadium: "Mercedes-Benz Stadium",
      link: "/api/v1/teams/1",
    }
  end

  describe "#initialize" do
    it "takes a hash and contains values" do
      expect(team.id).to eq 1
      expect(team.franchise_id).to eq 23
      expect(team.name).to eq "Atlanta United"
      expect(team.abbreviation).to eq "ATL"
      expect(team.stadium).to eq "Mercedes-Benz Stadium"
      expect(team.link).to eq "/api/v1/teams/1"
    end
  end

  describe "#average_score" do
    it "returns the average score across all the team's games" do
      games = [
        double("Game", home_team_id: 1, home_goals: 2),
        double("Game", home_team_id: 1, home_goals: 3),
        double("Game", home_team_id: 0, away_goals: 2),
        double("Game", home_team_id: 0, away_goals: 1),
      ]
      team = build_team
      allow(team)
        .to receive(:games)
        .and_return(games)

      expect(team.average_score).to eq 2
    end
  end

  describe "#away_games" do
    it "returns all games where game.away_team_id == team.id" do
      games = [
        double("Game", away_team_id: 1),
        double("Game", away_team_id: 1),
        double("Game", away_team_id: 2),
        double("Game", away_team_id: 2),
      ]
      team = build_team
      allow(team)
        .to receive(:games)
        .and_return(games)

      expect(team.away_games).to eq games[0..1]
    end
  end

  private

  def build_team
    Team.new(raw_attributes)
  end
end
