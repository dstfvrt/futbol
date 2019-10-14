module Helpers
  def build_stat_tracker
    filepaths = Hash.new
    filepaths[:games] = "./spec/fixtures/games.csv"
    filepaths[:teams] = "./spec/fixtures/teams.csv"
    filepaths[:gameteams] = "./spec/fixtures/game_teams.csv"

    StatTracker.new(filepaths)
  end
end
