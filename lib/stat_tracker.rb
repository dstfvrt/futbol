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
    @games.records.max_by(&:total_score).total_score
  end

  def lowest_total_score
    @games.records.min_by(&:total_score).total_score
  end

  def biggest_blowout
    @games.records.max_by(&:score_difference).score_difference
  end

  def percentage_home_wins
    home_wins = @games.records.count do |record|
      record.home_goals > record.away_goals
    end
    count = @games.records.count
    percentage = ((home_wins.to_f / count.to_f) * 100).round(3)
  end

  def percentage_visitor_wins
    away_wins = @games.records.count do |record|
      record.away_goals > record.home_goals
    end
    count = @games.records.count
    percentage = ((away_wins.to_f / count.to_f) * 100).round(3)
  end

  def percentage_ties
    ties = @games.records.count do |record|
      record.away_goals == record.home_goals
    end
    count = @games.records.count
    percentage = ((ties.to_f / count.to_f) * 100).round(3)
  end

  def average_goals_per_game
  end
end
