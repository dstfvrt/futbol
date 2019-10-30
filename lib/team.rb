require "./lib/record"

class Team < Record
  def abbreviation
    attributes[:abbreviation]
  end

  def all_goals_scored
    games.map do |game|
      if game.home_team_id == id
        game.home_goals
      else
        game.away_goals
      end
    end
  end

  def average_allowed_goals
    games.sum do |game|
      if game.home_team_id == id
        game.away_goals
      else
        game.home_goals
      end
    end / (games.size.nonzero? || 1)
  end

  def average_home_score
    home_games.sum(&:home_goals) / (home_games.size.nonzero? || 1)
  end

  def average_score
    games.sum do |game|
      if game.home_team_id == id
        game.home_goals
      else
        game.away_goals
      end
    end / (games.size.nonzero? || 1)
  end

  def average_visiting_score
    away_games.sum(&:away_goals) / (away_games.size.nonzero? || 1)
  end

  def away_games
    games.select { |game| game.away_team_id == id }
  end

  def away_record
    (away_games.count do |game|
      game.winner?(self)
    end / (away_games.size.nonzero? || 1).to_f).to_f
  end

  def franchise_id
    attributes[:franchiseid].to_i
  end

  def games
    @games ||= build_games
  end

  def home_games
    games.select { |game| game.home_team_id == id }
  end

  def home_record
    (home_games.count do |game|
      game.winner?(self)
    end / (home_games.size.nonzero? || 1).to_f).to_f
  end

  def link
    @attributes[:link]
  end

  def stadium
    attributes[:stadium]
  end

  def id
    @attributes[:team_id].to_i
  end

  def name
    @attributes[:teamname]
  end

  def number_of_wins
    games.count { |game| game.winner?(self) }
  end

  def number_lost_by_season
    seasons = games.map(&:season).uniq

    seasons.each_with_object({}) do |season, hash|
      season_games = games.select do |game|
        game.season == season
      end

      hash[season] = season_games.count do |game|
        game.losing_team_id == id
      end
    end
  end

  def number_of_wins_by_season
    seasons = games.map(&:season).uniq

    seasons.each_with_object({}) do |season, hash|
      season_games = games.select do |game|
        game.season == season
      end

      hash[season] = season_games.count do |game|
        game.winning_team_id == id
      end
    end
  end

  def opponents
    games.map do |game|
      if game.home_team_id == id
        game.away_team_id
      else
        game.home_team_id
      end
    end.uniq!
  end

  private

  def build_games
    database.games.select do |game|
      game.home_team_id == id || game.away_team_id == id
    end
  end
end
