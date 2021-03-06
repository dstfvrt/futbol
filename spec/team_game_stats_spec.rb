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

  describe "#average_against_by_season" do
    it "returns the average score against across all games for that season" do
      team = instance_double(Team, id: 1)
      season = "20132014"
      type = :post_season
      games = [
        double("Game", {
          home_team_id: 1,
          home_goals: 1,
          away_goals: 2,
          season: "20122013",
          season_type: :post_season,
        }),
        double("Game", {
          home_team_id: 1,
          home_goals: 3,
          away_goals: 2,
          season: "20132014",
          season_type: :post_season,
        }),
        double("Game", {
          home_team_id: 2,
          away_team_id: 1,
          home_goals: 4,
          away_goals: 2,
          season: "20132014",
          season_type: :post_season,
        }),
        double("Game", {
          home_team_id: 2,
          away_team_id: 1,
          home_goals: 3,
          away_goals: 2,
          season: "20122013",
          season_type: :regular_season,
        }),
      ]
      game_stats = build_game_stats(team: team, games: games)

      expect(game_stats.average_against_by_season(season, type)).to eq 3.0
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

  describe "#average_score_by_season" do
    it "returns the average score across all games for that season" do
      team = instance_double(Team, id: 1)
      season = "20132014"
      type = :post_season
      games = [
        double("Game", {
          home_team_id: 1,
          home_goals: 1,
          season: "20122013",
          season_type: :post_season,
        }),
        double("Game", {
          home_team_id: 1,
          home_goals: 3,
          season: "20132014",
          season_type: :post_season,
        }),
        double("Game", {
          home_team_id: 2,
          away_team_id: 1,
          away_goals: 2,
          season: "20132014",
          season_type: :post_season,
        }),
        double("Game", {
          home_team_id: 2,
          away_team_id: 1,
          away_goals: 2,
          season: "20122013",
          season_type: :regular_season,
        }),
      ]
      game_stats = build_game_stats(team: team, games: games)

      expect(game_stats.average_score_by_season(season, type)).to eq 2.5
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

  describe "#avg_win_percentage_by_season" do
    it "returns the average score across all games for that season" do
      team = instance_double(Team, id: 1)
      season = "20132014"
      type = :post_season
      games = [
        double("Game", {
          home_team_id: 1,
          winner?: true,
          season: "20122013",
          season_type: :post_season,
        }),
        double("Game", {
          home_team_id: 1,
          winner?: false,
          season: "20132014",
          season_type: :post_season,
        }),
        double("Game", {
          home_team_id: 2,
          away_team_id: 1,
          winner?: true,
          season: "20132014",
          season_type: :post_season,
        }),
        double("Game", {
          home_team_id: 2,
          away_team_id: 1,
          winner?: false,
          season: "20122013",
          season_type: :regular_season,
        }),
      ]
      game_stats = build_game_stats(team: team, games: games)

      expect(game_stats.avg_win_percentage_by_season(season, type)).to eq 50.0
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
        double("Game", home_team_id: 1, away_team_id: 2, has_team?: true),
        double("Game", home_team_id: 2, away_team_id: 1, has_team?: true),
        double("Game", home_team_id: 3, away_team_id: 1, has_team?: false),
        double("Game", home_team_id: 1, away_team_id: 3, has_team?: false),
      ]
      game_stats = build_game_stats(team: team, games: games)

      expect(game_stats.games_against_team(opponent)).to eq 2
    end
  end

  describe "#games_by_season" do
    it "returns an array of all games the team participated in a season" do
      team = instance_double(Team, id: 1)
      season = "20122013"
      type = :post_season
      games = [
        double("Game", {
          home_team_id: 1,
          home_goals: 1,
          season: "20122013",
          season_type: :post_season,
        }),
        double("Game", {
          home_team_id: 1,
          home_goals: 3,
          season: "20132014",
          season_type: :post_season,
        }),
        double("Game", {
          home_team_id: 2,
          away_team_id: 1,
          away_goals: 2,
          season: "20132014",
          season_type: :post_season,
        }),
        double("Game", {
          home_team_id: 2,
          away_team_id: 1,
          away_goals: 2,
          season: "20122013",
          season_type: :post_season,
        }),
      ]
      game_stats = build_game_stats(team: team, games: games)

      expect(game_stats.games_by_season(season, type)).to eq 2
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
        double("Game", {
          winning_team_id: 1,
          home_team_id: 1,
          away_team_id: 2,
          has_team?: true,
        }),
        double("Game", {
          winning_team_id: 1,
          home_team_id: 2,
          away_team_id: 1,
          has_team?: true,
        }),
        double("Game", {
          winning_team_id: 2,
          home_team_id: 1,
          away_team_id: 2,
          has_team?: true,
        }),
        double("Game", {
          winning_team_id: 1,
          home_team_id: 1,
          away_team_id: 3,
          has_team?: false,
        }),
      ]
      game_stats = build_game_stats(team: team, games: games)

      expect(game_stats.number_of_wins_against_team(opponent)).to eq 2
    end
  end

  describe "#number_of_wins_by_season" do
    it "returns the total number of games the team has won in a season" do
      team = instance_double(Team, id: 1)
      season = "20122013"
      type = :post_season
      games = [
        double("Game", {
          home_team_id: 1,
          winner?: true,
          season: "20122013",
          season_type: :post_season,
        }),
        double("Game", {
          home_team_id: 1,
          winner?: true,
          season: "20132014",
          season_type: :post_season,
        }),
        double("Game", {
          home_team_id: 2,
          away_team_id: 1,
          winner?: true,
          season: "20132014",
          season_type: :post_season,
        }),
        double("Game", {
          home_team_id: 2,
          away_team_id: 1,
          winner?: true,
          season: "20122013",
          season_type: :post_season,
        }),
      ]
      game_stats = build_game_stats(team: team, games: games)

      expect(game_stats.number_of_wins_by_season(season, type)).to eq 2
    end
  end

  describe "#number_of_wins_by_season_hash" do
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

      expect(game_stats.number_of_wins_by_season_hash).to eq team_hash
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
  describe "#all_goals_against_by_season" do
    it "returns all the goals a team has been scored on in a season" do
      team = instance_double(Team, id: 1)
      season = "20122013"
      type = :post_season
      games = [
        double("Game", {
          home_team_id: 1,
          home_goals: 1,
          away_goals: 2,
          season: "20122013",
          season_type: :post_season,
        }),
        double("Game", {
          home_team_id: 1,
          home_goals: 3,
          away_goals: 2,
          season: "20132014",
          season_type: :post_season,
        }),
        double("Game", {
          home_team_id: 2,
          away_team_id: 1,
          home_goals: 3,
          away_goals: 2,
          season: "20132014",
          season_type: :post_season,
        }),
        double("Game", {
          home_team_id: 2,
          away_team_id: 1,
          home_goals: 3,
          away_goals: 2,
          season: "20122013",
          season_type: :post_season,
        }),
      ]
      game_stats = build_game_stats(team: team, games: games)

      expect(game_stats.all_goals_against_by_season(season, type)).to eq 5
    end
  end

  describe "#all_goals_scored_by_season" do
    it "returns all the goals a team has scored in a season" do
      team = instance_double(Team, id: 1)
      season = "20122013"
      type = :post_season
      games = [
        double("Game", {
          home_team_id: 1,
          home_goals: 1,
          season: "20122013",
          season_type: :post_season,
        }),
        double("Game", {
          home_team_id: 1,
          home_goals: 3,
          season: "20132014",
          season_type: :post_season,
        }),
        double("Game", {
          home_team_id: 2,
          away_team_id: 1,
          away_goals: 2,
          season: "20132014",
          season_type: :post_season,
        }),
        double("Game", {
          home_team_id: 2,
          away_team_id: 1,
          away_goals: 2,
          season: "20122013",
          season_type: :post_season,
        }),
      ]
      game_stats = build_game_stats(team: team, games: games)

      expect(game_stats.all_goals_scored_by_season(season, type)).to eq 3
    end
  end

  describe "#opponents" do
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

  describe "#season_information" do
    it "returns an array of opponents of a team" do
      team = instance_double(Team, id: 1)
      season = "20122013"
      type = :post_season
      games = [
        double("Game", {
          home_team_id: 1,
          home_goals: 1,
          away_goals: 2,
          winner?: true,
          season: "20122013",
          season_type: :post_season,
        }),
        double("Game", {
          home_team_id: 1,
          home_goals: 3,
          away_goals: 2,
          season: "20132014",
          season_type: :post_season,
        }),
        double("Game", {
          home_team_id: 2,
          away_team_id: 1,
          home_goals: 3,
          away_goals: 2,
          winner?: false,
          season: "20122013",
          season_type: :regular_season,
        }),
        double("Game", {
          home_team_id: 2,
          away_team_id: 1,
          home_goals: 3,
          away_goals: 2,
          winner?: false,
          season: "20122013",
          season_type: :post_season,
        }),
      ]
      game_stats = build_game_stats(team: team, games: games)

      information = {
        win_percentage: 50.0,
        total_goals_scored: 3,
        total_goals_against: 5,
        average_goals_scored: 1.5,
        average_goals_against: 2.5,
      }

      expect(game_stats.season_information(season, type)).to eq information
    end
  end

  describe "#season_games" do
    it "returns an array of games with the given season" do
      team = instance_double(Team, id: 1)
      games = [
        double("Game", {
          season: "1",
        }),
        double("Game", {
          season: "1",
        }),
        double("Game", {
          season: "2",
        }),
        double("Game", {
          season: "3",
        }),
      ]
      game_stats = build_game_stats(team: team, games: games)

      season_games = game_stats.season_games("1")

      expect(season_games).to eq games[0..1]
      expect(game_stats.season_games("2").size).to eq 1
      expect(game_stats.season_games("Bad Key").size).to eq 0
    end
  end

  describe "#seasonal_win_percentage_difference" do
    it "returns the difference of win percentages between regular and post " +
      "season games for a given season" do
      team = instance_double(Team, id: 1)
      games = [
        double("Game", {
          home_team_id: 1,
          season: "1",
          type: "Regular Season",
          winner?: true,
        }),
        double("Game", {
          home_team_id: 1,
          season: "1",
          type: "Regular Season",
          winner?: false,
        }),
        double("Game", {
          home_team_id: 1,
          season: "1",
          type: "Regular Season",
          winner?: true,
        }),
        double("Game", {
          home_team_id: 1,
          season: "1",
          type: "Regular Season",
          winner?: false,
        }),
        double("Game", {
          home_team_id: 1,
          season: "1",
          type: "Postseason",
          winner?: true,
        }),
        double("Game", {
          home_team_id: 1,
          season: "1",
          type: "Postseason",
          winner?: true,
        }),
        double("Game", {
          home_team_id: 1,
          season: "1",
          type: "Postseason",
          winner?: true,
        }),
        double("Game", {
          home_team_id: 1,
          season: "1",
          type: "Postseason",
          winner?: true,
        }),
      ]

      game_stats = build_game_stats(team: team, games: games)
      expect(game_stats.seasonal_win_percentage_difference("1")).to eq -50
    end
  end

  private

  def build_game_stats(team:, games:)
    TeamGameStats.new(team: team, games: games)
  end
end
