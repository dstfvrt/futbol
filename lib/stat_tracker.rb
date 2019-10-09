require "csv"
require "./lib/repository"
require "./lib/game"
require "./lib/team"
require "./lib/game_team"
class StatTracker
  attr_reader :games, :teams, :game_teams

  def initialize
    @games = Repository.new("./data/games.csv", Game)
    @teams = Repository.new("./data/teams.csv", Team)
    @game_teams = Repository.new("./data/game_teams.csv", GameTeam)
  end

  def best_offense

  end

  def count_of_teams
    @teams.records.size
  end
end
