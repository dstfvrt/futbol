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

  def best_offense
    @teams.records.max_by do |team|
      goals = games.records.sum do |game|
      end
    end
  end

  def count_of_teams
    @teams.records.size
  end
end
