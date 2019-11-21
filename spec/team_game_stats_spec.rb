require "./lib/team"
require "./lib/team_game_stats"

RSpec.describe TeamGameStats do
  describe "#initialize" do
    it "takes in a team, and the team's games" do
      team = double("Team", id: 1)
      games = [
        double("Game", home_team_id: 1, away_team_id: 0),
        double("Game", home_team_id: 1, away_team_id: 0),
      ]
      game_stats = TeamGameStats.new(team: team, games: games)

      expect(game_stats.team).to eq team
      expect(game_stats.games).to eq games
    end
  end

  describe "#average_allowed_goals" do
    it "returns the average number of goals scored by the enemy team" do
      team = instance_double(Team, id: 1)
      games = [
        double("Game", home_team_id: team.id, away_goals: 3, away_team_id: 0),
        double("Game", home_team_id: 0, home_goals: 7, away_team_id: team.id),
      ]
      game_stats = build_game_stats(team: team, games: games)

      expect(game_stats.average_allowed_goals).to eq 5
    end
  end

  describe "#average_home_score" do
    it "returns the average score of all home games" do
      team = instance_double(Team, id: 1)
      games = [
        double("Game", home_team_id: 1, home_goals: 3, away_team_id: 0),
        double("Game", home_team_id: 0, home_goals: 4, away_team_id: 0),
        double("Game", home_team_id: 1, home_goals: 5, away_team_id: 0),
      ]
      game_stats = build_game_stats(team: team, games: games)

      expect(game_stats.average_home_score).to eq 4
    end
  end

  describe "#average_score" do
    it "returns the average score across all games" do
      team = instance_double(Team, id: 1)
      games = [
        double("Game", home_team_id: 1, home_goals: 3, away_team_id: 0,
                       away_goals: 0),
        double("Game", home_team_id: 0, home_goals: 4, away_team_id: 1,
                       away_goals: 4),
        double("Game", home_team_id: 1, home_goals: 5, away_team_id: 0,
                       away_goals: 0),
      ]
      game_stats = build_game_stats(team: team, games: games)

      expect(game_stats.average_score).to eq 4
    end
  end

  describe "#average_visiting_score" do
    it "returns the average score across all away games" do
      team = instance_double(Team, id: 1)
      games = [
        double("Game", home_team_id: 0, home_goals: 0, away_team_id: 1,
                       away_goals: 2),
        double("Game", home_team_id: 0, home_goals: 0, away_team_id: 1,
                       away_goals: 4),
        double("Game", home_team_id: 1, home_goals: 5, away_team_id: 0,
                       away_goals: 0),
      ]
      game_stats = build_game_stats(team: team, games: games)

      expect(game_stats.average_visiting_score).to eq 3
    end
  end

  describe "#away_games" do
    it "returns an array of all games where the team is a visitor" do
      team = instance_double(Team, id: 1)
      games = [
        double("Game", home_team_id: 0, away_team_id: 1),
        double("Game", home_team_id: 0, away_team_id: 1),
        double("Game", home_team_id: 1, away_team_id: 0),
      ]
      game_stats = build_game_stats(team: team, games: games)

      expect(game_stats.away_games).to eq (games
        .select { |game| game.away_team_id == team.id })
    end
  end

  describe "#away_record" do
    it "returns a decimal percentage of the teams visiting win ratio" do
      team = instance_double(Team, id: 1)
      games = [
        double("Game", home_team_id: 0, away_team_id: 1, winner?: true),
        double("Game", home_team_id: 0, away_team_id: 1, winner?: false),
        double("Game", home_team_id: 1, away_team_id: 0, winner?: true),
        double("Game", home_team_id: 1, away_team_id: 0, winner?: false),
      ]
      game_stats = build_game_stats(team: team, games: games)

      expect(game_stats.away_record).to eq 0.5
    end
  end

  describe "#games" do
    it "returns an array of all games the team participated in" do
      team = instance_double(Team, id: 1)
      games = [
        double("Game", home_team_id: 1, away_team_id: 0),
        double("Game", home_team_id: 0, away_team_id: 1),
      ]
      game_stats = build_game_stats(team: team, games: games)

      expect(game_stats.games).to eq games
    end
  end

  describe "#games_against_team" do
    it "returns an array of all games the team participated in" do
      team = instance_double(Team, id: 1)
      opponent = 2
      games = [
        double("Game", home_team_id: 1, away_team_id: 2),
        double("Game", home_team_id: 2, away_team_id: 1),
        double("Game", home_team_id: 3, away_team_id: 1),
        double("Game", home_team_id: 1, away_team_id: 3),
      ]
      game_stats = build_game_stats(team: team, games: games)

      expect(game_stats.games_against_team(opponent)).to eq 2
    end
  end
  describe "#home_games" do
    it "returns an array of all games where the team is home" do
      team = instance_double(Team, id: 1)
      games = [
        double("Game", home_team_id: 1, away_team_id: 0),
        double("Game", home_team_id: 0, away_team_id: 1),
        double("Game", home_team_id: 0, away_team_id: 0),
      ]
      game_stats = build_game_stats(team: team, games: games)

      expect(game_stats.home_games).to eq (games
        .select { |game| game.home_team_id == team.id })
    end
  end

  describe "#home_record" do
    it "returns a decimal percentage of the teams home win ratio" do
      team = instance_double(Team, id: 1)
      games = [
        double("Game", home_team_id: 0, away_team_id: 1, winner?: true),
        double("Game", home_team_id: 0, away_team_id: 1, winner?: false),
        double("Game", home_team_id: 1, away_team_id: 0, winner?: true),
        double("Game", home_team_id: 1, away_team_id: 0, winner?: false),
      ]
      game_stats = build_game_stats(team: team, games: games)

      expect(game_stats.home_record).to eq 0.5
    end
  end

  describe "#number_of_wins" do
    it "returns the total number of games the team has won" do
      team = instance_double(Team, id: 1)
      games = [
        double("Game", home_team_id: 0, away_team_id: 1, winner?: true),
        double("Game", home_team_id: 0, away_team_id: 1, winner?: false),
        double("Game", home_team_id: 1, away_team_id: 0, winner?: true),
        double("Game", home_team_id: 1, away_team_id: 0, winner?: false),
      ]
      game_stats = build_game_stats(team: team, games: games)

      expect(game_stats.number_of_wins).to eq 2
    end
  end
  describe "#number_of_wins_against_team" do
    it "returns a hash of seasons with their related win counts" do
      team = instance_double(Team, id: 1)
      opponent = 2
      games = [
        double("Game", winning_team_id: 1, home_team_id: 1, away_team_id: 2),
        double("Game", winning_team_id: 1, home_team_id: 2, away_team_id: 1),
        double("Game", winning_team_id: 2, home_team_id: 1, away_team_id: 2),
        double("Game", winning_team_id: 1, home_team_id: 1, away_team_id: 3),
      ]
      game_stats = build_game_stats(team: team, games: games)

      expect(game_stats.number_of_wins_against_team(opponent)).to eq 2
    end
  end
  describe "#number_of_wins_by_season" do
    it "returns a hash of seasons with their related win counts" do
      team = instance_double(Team, id: 1)
      games = [
        double("Game", season: 20122013, winning_team_id: 1, home_team_id: 1),
        double("Game", season: 20122013, winning_team_id: 1, home_team_id: 1),
        double("Game", season: 20132014, winning_team_id: 1, home_team_id: 1),
        double("Game", season: 20132014, winning_team_id: 2, home_team_id: 1),
      ]
      game_stats = build_game_stats(team: team, games: games)

      team_hash = {
        20122013 => 2,
        20132014 => 1,
      }

      expect(game_stats.number_of_wins_by_season).to eq team_hash
    end
  end

  describe "#number_lost_by_season" do
    it "returns a hash of seasons with their related losing counts" do
      team = instance_double(Team, id: 1)
      games = [
        double("Game", season: 20122013, losing_team_id: 1, home_team_id: 1),
        double("Game", season: 20122013, losing_team_id: 1, home_team_id: 1),
        double("Game", season: 20132014, losing_team_id: 1, home_team_id: 1),
        double("Game", season: 20132014, losing_team_id: 2, home_team_id: 1),
      ]
      game_stats = build_game_stats(team: team, games: games)

      team_hash = {
        20122013 => 2,
        20132014 => 1,
      }

      expect(game_stats.number_lost_by_season).to eq team_hash
    end
  end

  describe "#all_goals_scored" do
    it "returns an array of all the goals a team has scored" do
      team = instance_double(Team, id: 1)
      games = [
        double("Game", home_team_id: 1, home_goals: 1),
        double("Game", home_team_id: 1, home_goals: 3),
        double("Game", home_team_id: 2, away_team_id: 1, away_goals: 2),
      ]
      game_stats = build_game_stats(team: team, games: games)

      goals_array = [1, 3, 2]

      expect(game_stats.all_goals_scored).to eq goals_array
    end
  end

  describe "#oppenents" do
    it "returns an array of opponents of a team" do
      team = instance_double(Team, id: 1)
      opponent_array = [2, 3]
      games = [
        double("Game", {
          home_team_id: 1,
          away_team_id: 2,
        }),
        double("Game", {
          home_team_id: 1,
          away_team_id: 2,
        }),
        double("Game", {
          home_team_id: 1,
          away_team_id: 3,
        }),
        double("Game", {
          home_team_id: 3,
          away_team_id: 1,
        }),
      ]
      game_stats = build_game_stats(team: team, games: games)

      expect(game_stats.opponents).to eq opponent_array
    end
  end

  private

  def build_game_stats(team:, games:)
    TeamGameStats.new(team: team, games: games)
  end
end
