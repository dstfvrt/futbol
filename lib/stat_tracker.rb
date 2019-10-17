require "csv"
require "./lib/repository"
require "./lib/game"
require "./lib/team"
require "./lib/game_team"

class StatTracker
  attr_reader :games_repo, :teams_repo, :game_teams_repo

  def initialize(filepaths)
    @games_repo = build_repo(filepaths[:games], Game)
    @teams_repo = build_repo(filepaths[:teams], Team)
    @game_teams_repo = build_repo(filepaths[:gameteams], GameTeam)
  end

  def average_goals_per_game
    all_scores = games.map(&:total_score).inject(:+)
    average(all_scores, total_games)
  end

  def average_goals_by_season
    seasons = games.map(&:season).uniq
    seasons.each_with_object({}) do |season, hash|
      season_games = find_games_from_season(season)
      hash[season] = calculate_average_score_for_games(season_games)
    end
  end

  def biggest_blowout
    games.map(&:score_difference).max
  end

  def count_of_games_by_season
    seasons = games.map(&:season).uniq
    seasons.each_with_object({}) do |season, hash|
      hash[season] = find_games_from_season(season).count
    end
  end

  def game_teams
    game_teams_repo.records
  end

  def games
    games_repo.records
  end

  def highest_total_score
    games.map(&:total_score).max
  end

  def lowest_total_score
    games.map(&:total_score).min
  end

  def percentage_home_wins
    home_wins = games.count(&:home_win?)
    percentage(home_wins, total_games)
  end

  def percentage_ties
    ties = games.count(&:tie?)
    percentage(ties, total_games)
  end

  def percentage_visitor_wins
    away_wins = games.count(&:away_win?)
    percentage(away_wins, total_games)
  end

  def teams
    teams_repo.records
  end

  def total_games
    games.count
  end

  private

  def average(dividend, divisor)
    (dividend / divisor.to_f).round(3)
  end

  def build_repo(filepath, class_name)
    Repository.new(filepath, class_name)
  end

  def calculate_average_score_for_games(games)
    total_games_score = games.map(&:total_score).inject(:+)
    average(total_games_score, games.count)
  end

  def find_games_from_season(season)
    games.select do |game|
      game.season == season
    end
  end

  def percentage(dividend, divisor)
    ((dividend / divisor.to_f) * 100).round(3)
  end
end
