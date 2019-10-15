require "csv"
require "./lib/repository"
require "./lib/game"
require "./lib/team"
require "./lib/game_team"

class StatTracker
  attr_reader :games, :teams, :game_teams

  def initialize(filepaths)
    @games = Repository.new(filepaths[:games], Game)
    @teams = Repository.new(filepaths[:teams], Team)
    @game_teams = Repository.new(filepaths[:gameteams], GameTeam)
  end

  def highest_total_score
    games.records.map(&:total_score).max
  end

  def lowest_total_score
    games.records.map(&:total_score).min
  end

  def biggest_blowout
    games.records.map(&:score_difference).max
  end

  def percentage_home_wins
    home_wins = games.records.count(&:home_win?)
    count = games.records.count
    percentage(home_wins, count)
  end

  def percentage_visitor_wins
    away_wins = games.records.count(&:away_win?)
    count = games.records.count
    percentage(away_wins, count)
  end

  def percentage_ties
    ties = games.records.count(&:tie?)
    count = games.records.count
    percentage(ties, count)
  end

  def count_of_games_by_season
    seasons = games.records.map(&:season).uniq
    seasons.each_with_object({}) do |season, hash|
      hash[season] = games.records.count do |game|
        game.season == season
      end
    end
  end

  def average_goals_per_game
    all_scores = games.records.map(&:total_score).inject(:+)
    count = games.records.count
    (all_scores / count.to_f).round(3)
  end

  def average_goals_by_season
    seasons = games.records.map(&:season).uniq
    seasons.each_with_object({}) do |season, hash|
      hash[season] = games.records.count do |game|
        game.season == season
      end
    end
  end

  private

  def percentage(divisor, count)
    ((divisor / count.to_f) * 100).round(3)
  end
end
