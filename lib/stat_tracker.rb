require "csv"
require "pry"
class StatTracker
  def initialize
    @games = Hash.new
    @teams = Hash.new
    @games_teams = Hash.new
  end
end
