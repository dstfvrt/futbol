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

  describe "#average_allowed_goals" do
    it "returns the average number of goals scored by the enemy team" do
      games = [
        double("Game", home_team_id: 1, away_goals: 3, away_team_id: 0),
        double("Game", home_team_id: 0, home_goals: 7, away_team_id: 1),
      ]
      allow(team).to receive(:games).and_return(games)

      expect(team.average_allowed_goals).to eq 5
    end
  end

  describe "#average_home_score" do
    it "returns the average score of all home games" do
      games = [
        double("Game", home_team_id: 1, home_goals: 3),
        double("Game", home_team_id: 0, home_goals: 4),
        double("Game", home_team_id: 1, home_goals: 5),
      ]
      allow(team).to receive(:games).and_return(games)

      expect(team.average_home_score).to eq 4
    end
  end

  describe "#average_score" do
    it "returns the average score across all games" do
      games = [
        double("Game", home_team_id: 1, home_goals: 3, away_team_id: 0,
                       away_goals: 0),
        double("Game", home_team_id: 0, home_goals: 4, away_team_id: 1,
                       away_goals: 4),
        double("Game", home_team_id: 1, home_goals: 5, away_team_id: 0,
                       away_goals: 0),
      ]
      allow(team).to receive(:games).and_return(games)

      expect(team.average_score).to eq 4
    end
  end

  describe "#average_visiting_score" do
    it "returns the average score across all away games" do
      games = [
        double("Game", home_team_id: 0, home_goals: 0, away_team_id: 1,
                       away_goals: 2),
        double("Game", home_team_id: 0, home_goals: 0, away_team_id: 1,
                       away_goals: 4),
        double("Game", home_team_id: 1, home_goals: 5, away_team_id: 0,
                       away_goals: 0),
      ]
      allow(team).to receive(:games).and_return(games)

      expect(team.average_visiting_score).to eq 3
    end
  end

  describe "#away_games" do
    it "returns an array of all games where the team is a visitor" do
      games = [
        double("Game", home_team_id: 0, away_team_id: 1),
        double("Game", home_team_id: 0, away_team_id: 1),
        double("Game", home_team_id: 1, away_team_id: 0),
      ]
      allow(team).to receive(:games).and_return(games)

      expect(team.away_games).to eq (games
        .select { |game| game.away_team_id == team.id })
    end
  end

  describe "#away_record" do
    it "returns a decimal percentage of the teams visiting win ratio" do
      games = [
        double("Game", home_team_id: 0, away_team_id: 1, winner?: true),
        double("Game", home_team_id: 0, away_team_id: 1, winner?: false),
        double("Game", home_team_id: 1, away_team_id: 0, winner?: true),
        double("Game", home_team_id: 1, away_team_id: 0, winner?: false),
      ]
      allow(team).to receive(:games).and_return(games)

      expect(team.away_record).to eq 0.5
    end
  end

  describe "#games" do
    it "returns an array of all games the team participated in" do
      games = [
        double("Game", home_team_id: 1, away_team_id: 0),
        double("Game", home_team_id: 0, away_team_id: 1),
        double("Game", home_team_id: 0, away_team_id: 0),
      ]
      allow(team.database).to receive(:games).and_return(games)

      expect(team.games).to eq (games
        .select do |game|
          game.away_team_id == team.id || game.home_team_id == team.id
        end)
    end
  end

  describe "#home_games" do
    it "returns an array of all games where the team is home" do
      games = [
        double("Game", home_team_id: 1, away_team_id: 0),
        double("Game", home_team_id: 0, away_team_id: 1),
        double("Game", home_team_id: 0, away_team_id: 0),
      ]
      allow(team.database).to receive(:games).and_return(games)

      expect(team.home_games).to eq (games
        .select { |game| game.home_team_id == team.id })
    end
  end

  describe "#home_record" do
    it "returns a decimal percentage of the teams home win ratio" do
      games = [
        double("Game", home_team_id: 0, away_team_id: 1, winner?: true),
        double("Game", home_team_id: 0, away_team_id: 1, winner?: false),
        double("Game", home_team_id: 1, away_team_id: 0, winner?: true),
        double("Game", home_team_id: 1, away_team_id: 0, winner?: false),
      ]
      allow(team).to receive(:games).and_return(games)

      expect(team.home_record).to eq 0.5
    end
  end

  describe "#number_of_wins" do
    it "returns the total number of games the team has won" do
      games = [
        double("Game", home_team_id: 0, away_team_id: 1, winner?: true),
        double("Game", home_team_id: 0, away_team_id: 1, winner?: false),
        double("Game", home_team_id: 1, away_team_id: 0, winner?: true),
        double("Game", home_team_id: 1, away_team_id: 0, winner?: false),
      ]
      allow(team).to receive(:games).and_return(games)

      expect(team.number_of_wins).to eq 2
    end
  end

  describe "#number_of_wins_by_season" do
    it "returns a hash of seasons with their related win counts" do
      team = build_team
      games = [
        instance_double(Game, season: 20122013, winning_team_id: 1),
        instance_double(Game, season: 20122013, winning_team_id: 1),
        instance_double(Game, season: 20132014, winning_team_id: 1),
        instance_double(Game, season: 20132014, winning_team_id: 2),
      ]
      allow(team)
        .to receive(:games)
        .and_return(games)

      team_hash = {
        20122013 => 2,
        20132014 => 1,
      }
      expect(team.number_of_wins_by_season).to eq team_hash
    end
  end

  describe "#number_lost_by_season" do
    it "returns a hash of seasons with their related losing counts" do
      team = build_team
      games = [
        instance_double(Game, season: 20122013, losing_team_id: 1),
        instance_double(Game, season: 20122013, losing_team_id: 1),
        instance_double(Game, season: 20132014, losing_team_id: 1),
        instance_double(Game, season: 20132014, losing_team_id: 2),
      ]
      allow(team)
        .to receive(:games)
        .and_return(games)

      team_hash = {
        20122013 => 2,
        20132014 => 1,
      }
      expect(team.number_lost_by_season).to eq team_hash
    end
  end

  describe "#all_goals_scored" do
    it "returns an array of all the goals a team has scored" do
      team = build_team
      games = [
        instance_double(Game, home_team_id: 1, home_goals: 1),
        instance_double(Game, home_team_id: 1, home_goals: 3),
        instance_double(Game, home_team_id: 2, away_team_id: 1, away_goals: 2),
        instance_double(Game, home_team_id: 2, away_team_id: 2, away_goals: 4),
      ]
      allow(team)
        .to receive(:games)
        .and_return(games)

      goals_array = [1, 3, 2, 4]
      expect(team.all_goals_scored).to eq goals_array
    end
  end

  describe "#oppenents" do
    it "returns an array of opponents of a team" do
      team = build_team
      opponent_array = [2, 3]
      games = [
        instance_double(Game, {
          home_team_id: 1,
          away_team_id: 2,
        }),
        instance_double(Game, {
          home_team_id: 1,
          away_team_id: 2,
        }),
        instance_double(Game, {
          home_team_id: 1,
          away_team_id: 3,
        }),
        instance_double(Game, {
          home_team_id: 3,
          away_team_id: 1,
        }),
      ]
      allow(team)
        .to receive(:games)
        .and_return(games)

      expect(team.opponents).to eq opponent_array
    end
  end

  private

  def build_team
    Team.new(raw_attributes)
  end
end
