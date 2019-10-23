require "./lib/record"

class Team < Record
  attr_reader :games

  def initialize(attributes)
    super(attributes)
    @games = build_games
  end

  def abbreviation
    attributes[:abbreviation]
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
    home_games.sum do |game|
      game.home_goals
    end / (home_games.size.nonzero? || 1)
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
    away_games.sum do |game|
      game.away_goals
    end / (away_games.size.nonzero? || 1)
  end

  def away_games
    games.select { |game| game.away_team_id == id }
  end

  def franchise_id
    attributes[:franchiseid].to_i
  end

  def home_games
    games.select { |game| game.home_team_id == id }
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

  private

  def build_games
    database.games.select do |game|
      game.home_team_id == id || game.away_team_id == id
    end
  end
end
