require "csv"
require "./lib/repository"
require "./lib/game"
require "./lib/team"
require "./lib/game_team"
require "./lib/team_game_stats"

class StatTracker
  attr_reader :games_repo, :teams_repo, :game_teams_repo

  def initialize(filepaths)
    @games_repo = build_repo(filepaths[:games], Game, self)
    @teams_repo = build_repo(filepaths[:teams], Team, self)
    @game_teams_repo = build_repo(filepaths[:gameteams], GameTeam, self)
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

  def average_win_percentage(id)
    this_team = find_team_row(id)
    wins = this_team.number_of_wins
    num_games = this_team.games
    percentage(wins, num_games)
  end

  def average_win_percentage_against_team(id, opponent_id)
    # this_team = find_team_row(id)
    # opponent_team = find_team_row(opponent_id)

    # games = this_team.games.map do |game|
    #   game.
    # end
    # wins = this_team.number_of_wins_against_team(opponent_id)
    # num_games = this_team.games
    # percentage(wins, num_games)
  end

  def biggest_blowout
    games.map(&:score_difference).max
  end

  def best_defense
    team = teams.min_by do |team|
      team_game_stats = TeamGameStats.new(team: team, games: team.games)
      team_game_stats.average_allowed_goals
    end

    team.name
  end

  def best_fans
    team = teams.max_by do |team|
      team_game_stats = TeamGameStats.new(team: team, games: team.games)
      team_game_stats.home_record - team_game_stats.away_record
    end

    team.name
  end

  def best_offense
    team = teams.max_by do |team|
      team_game_stats = TeamGameStats.new(team: team, games: team.games)
      team_game_stats.average_score
    end

    team.name
  end

  def best_season(id)
    find_team_row(id)
      .number_of_wins_by_season
      .max_by { |_season, count| count }
      .first
  end

  def count_of_games_by_season
    seasons = games.map(&:season).uniq
    seasons.each_with_object({}) do |season, hash|
      hash[season] = find_games_from_season(season).count
    end
  end

  def count_of_teams
    teams.size
  end

  def favorite_opponent(id)
    opponents = find_team_row(id).opponents
    opponents.map do |opponent|
      average_win_percentage_against_team(opponent, id)
    end
      .min
  end

  def fewest_goals_scored(id)
    find_team_row(id).all_goals_scored.min
  end

  def find_team_row(id)
    teams.detect do |team|
      team.id == id
    end
  end

  def game_teams
    game_teams_repo.records
  end

  def games
    games_repo.records
  end

  def highest_scoring_visitor
    team = teams.max_by do |team|
      team_game_stats = TeamGameStats.new(team: team, games: team.games)
      team_game_stats.average_visiting_score
    end

    team.name
  end

  def highest_total_score
    games.map(&:total_score).max
  end

  def lowest_scoring_home_team
    team = teams.min_by do |team|
      team_game_stats = TeamGameStats.new(team: team, games: team.games)
      team_game_stats.average_home_score
    end

    team.name
  end

  def lowest_total_score
    games.map(&:total_score).min
  end

  def most_goals_scored(id)
    find_team_row(id).all_goals_scored.max
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

  def team_info(id)
    team = find_team_row(id)
    {
      "team_id" => id,
      "franchise_id" => team.franchise_id,
      "team_name" => team.name,
      "abbreviation" => team.abbreviation,
      "link" => team.link,
    }
  end

  def total_games
    games.count
  end

  def winningest_team
    team = teams.max_by do |team|
      team_game_stats = TeamGameStats.new(team: team, games: team.games)
      percentage(team_game_stats.number_of_wins, team.games.size)
    end

    team.name
  end

  def worst_defense
    team = teams.max_by do |team|
      team_game_stats = TeamGameStats.new(team: team, games: team.games)
      team_game_stats.average_allowed_goals
    end

    team.name
  end

  def worst_fans
    teams.select do |team|
      team_game_stats = TeamGameStats.new(team: team, games: team.games)
      team_game_stats.away_record > team_game_stats.home_record
    end
      .map(&:name)
  end

  def worst_offense
    team = teams.min_by do |team|
      team_game_stats = TeamGameStats.new(team: team, games: team.games)
      team_game_stats.average_score
    end

    team.name
  end

  def worst_season(id)
    find_team_row(id)
      .number_lost_by_season
      .max_by { |_season, count| count }
      .first
  end

  private

  def average(dividend, divisor)
    (dividend / divisor.to_f).round(3)
  end

  def build_repo(filepath, class_name, database)
    Repository.new(filepath, class_name, database)
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
    return 0 if divisor.zero?

    ((dividend / divisor.to_f) * 100).round(3)
  end
end
