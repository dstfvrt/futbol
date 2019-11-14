class TeamGameStats
  attr_reader :team

  def initialize(team:, games:)
    @all_games = games
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

  def average_visiting_score
    average(away_games.sum(&:away_goals), away_games.size)
  end

  def away_games
    games.select { |game| game.away_team_id == team.id }
  end

  def away_record
    number = away_games.count do |game|
      game.winner?(self)
    end

    average(number, away_games.size)
  end

  def games
    @games ||= build_games
  end

  def home_games
    games.select { |game| game.home_team_id == team.id }
  end

  def home_record
    (home_games.count do |game|
      game.winner?(self)
    end / (home_games.size.nonzero? || 1).to_f).to_f
  end

  def number_of_wins
    games.count { |game| game.winner?(self) }
  end

  def number_of_wins_against_team(opponent)
    games.count { |game| game.winner?(self) }
  end

  def number_of_wins_by_season
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

  private

  def average(dividend, divisor)
    return 0 if divisor.zero?

    dividend / divisor.to_f
  end

  def build_games
    @all_games.select do |game|
      game.home_team_id == team.id || game.away_team_id == team.id
    end
  end
end
