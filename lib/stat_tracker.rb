require "csv"
require "pry"
class StatTracker
  def initialize
    @games = Hash.new
    @teams = Hash.new
    @games_teams = Hash.new
  end

  def self.from_csv(locations)
    games_csv = CSV.open locations[:games], headers: true, header_converters: :symbol
    games_teams_csv = CSV.open locations[:game_teams], headers: true, header_converters: :symbol
    teams_csv = CSV.open locations[:teams], headers: true, header_converters: :symbol

    binding.pry
  end
end
