class TeamGameStats
  attr_reader :team, :games

  def initialize(team:, games:)
    @games = games
    @team = team
  end

  def all_goals_scored
    games.map do |game|
      if game.home_team_id == team.id
        game.home_goals
      else
        game.away_goals
      end
    end
  end

  def all_goals_scored_by_season(season, type)
    games.reduce(0) do |goals, game|
      if game.season == season && game.season_type == type
        if game.home_team_id == team.id
          goals + game.home_goals
        else
          goals + game.away_goals
        end
      else
        goals + 0
      end
    end
  end

  def all_goals_against_by_season(season, type)
    games.reduce(0) do |goals, game|
      if game.season == season && game.season_type == type
        if game.home_team_id == team.id
          goals + game.away_goals
        else
          goals + game.home_goals
        end
      else
        goals + 0
      end
    end
  end

  def average_against_by_season(season, type)
    number = all_goals_against_by_season(season, type)
    games = games_by_season(season, type)

    average(number, games).round(2)
  end

  def average_allowed_goals
    number = games.sum do |game|
      if game.home_team_id == team.id
        game.away_goals
      else
        game.home_goals
      end
    end

    average(number, games.count)
  end

  def average_home_score
    average(home_games.sum(&:home_goals), home_games.count)
  end

  def average_score
    number = games.sum do |game|
      if game.home_team_id == team.id
        game.home_goals
      else
        game.away_goals
      end
    end

    average(number, games.count)
  end

  def average_score_by_season(season, type)
    number = all_goals_scored_by_season(season, type)
    games = games_by_season(season, type)

    average(number, games).round(2)
  end

  def average_visiting_score
    average(away_games.sum(&:away_goals), away_games.size)
  end

  def avg_win_percentage_by_season(season, type)
    wins_by_season = number_of_wins_by_season(season, type)
    games = games_by_season(season, type)
    average(wins_by_season, games) * 100
  end

  def away_games
    games.select { |game| game.away_team_id == team.id }
  end

  def away_record
    number = away_games.count do |game|
      game.winner?(team)
    end

    average(number, away_games.size)
  end

  def calculate_seasonal_win_percentage(season, season_type)
    season_games =
      season_games(season).select do |game|
        game.type == season_type
      end

    season_wins =
      season_games.count do |game|
        game.winner?(team)
      end

    average(season_wins, season_games.size)
  end

  def games_against_team(opponent_id)
    games.count do |game|
      game.has_team?(opponent_id)
    end
  end

  def games_by_season(season, type)
    games.count do |game|
      game.season == season && game.season_type == type
    end
  end

  def home_games
    games.select { |game| game.home_team_id == team.id }
  end

  def home_record
    (home_games.count do |game|
      game.winner?(team)
    end / (home_games.size.nonzero? || 1).to_f).to_f
  end

  def number_of_wins
    games.count { |game| game.winner?(team) }
  end

  def number_of_wins_against_team(opponent_id)
    games.count do |game|
      if game.has_team?(opponent_id)
        game.winning_team_id == team.id
      end
    end
  end

  def number_of_wins_by_season(season, type)
    games.count do |game|
      if game.season == season && game.season_type == type
        game.winner?(team)
      end
    end
  end

  def number_of_wins_by_season_hash
    seasons = games.map(&:season).uniq

    seasons.each_with_object({}) do |season, hash|
      season_games = games.select do |game|
        game.season == season
      end

      hash[season] = season_games.count do |game|
        game.winning_team_id == team.id
      end
    end
  end

  def number_lost_by_season
    seasons = games.map(&:season).uniq

    seasons.each_with_object({}) do |season, hash|
      season_games = games.select do |game|
        game.season == season
      end

      hash[season] = season_games.count do |game|
        game.losing_team_id == team.id
      end
    end
  end

  def opponents
    games.map do |game|
      if game.home_team_id == team.id
        game.away_team_id
      else
        game.home_team_id
      end
    end.uniq!
  end

  def season_information(season, type)
    {
      win_percentage: avg_win_percentage_by_season(season, type),
      total_goals_scored: all_goals_scored_by_season(season, type),
      total_goals_against: all_goals_against_by_season(season, type),
      average_goals_scored: average_score_by_season(season, type),
      average_goals_against: average_against_by_season(season, type),
    }
  end

  def season_games(season)
    games.select do |game|
      game.season == season
    end
  end

  def seasonal_win_percentage_difference(season)

    regular_season_win_percent =
      calculate_seasonal_win_percentage(season, "Regular Season")

    post_season_win_percent =
      calculate_seasonal_win_percentage(season, "Postseason")

    (regular_season_win_percent - post_season_win_percent) * 100
  end

  private

  def average(dividend, divisor)
    return 0 if divisor.zero?

    dividend / divisor.to_f
  end
end
