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
    team_game_stats = get_stats_by_team(id)
    wins = team_game_stats.number_of_wins
    num_games = team_game_stats.games.count
    percentage(wins, num_games)
  end

  def average_win_percentage_against_team(id, opponent_id)
    this_team = get_stats_by_team(id)

    wins = this_team.number_of_wins_against_team(opponent_id)
    num_games = this_team.games_against_team(opponent_id)
    percentage(wins, num_games)
  end

  def best_defense
    team = teams.min_by do |t|
      team_game_stats = TeamGameStats.new(team: t, games: t.games)
      team_game_stats.average_allowed_goals
    end

    team.name
  end

  def best_fans
    team = teams.max_by do |t|
      team_game_stats = TeamGameStats.new(team: t, games: t.games)
      team_game_stats.home_record - team_game_stats.away_record
    end

    team.name
  end

  def best_offense
    team = teams.max_by do |t|
      team_game_stats = TeamGameStats.new(team: t, games: t.games)
      team_game_stats.average_score
    end

    team.name
  end

  def best_season(id)
    get_stats_by_team(id).number_of_wins_by_season_hash
      .max_by { |_season, count| count }
      .first
  end

  def biggest_blowout
    games.map(&:score_difference).max
  end

  def biggest_bust(season)
    teams.min_by do |team|
      team_games_stats = TeamGameStats.new(team: team, games: team.games)
      team_games_stats.seasonal_win_percentage_difference(season)
    end.name
  end

  def biggest_surprise(season)
    teams.max_by do |team|
      team_games_stats = TeamGameStats.new(team: team, games: team.games)
      team_games_stats.seasonal_win_percentage_difference(season)
    end.name
  end

  def biggest_team_blowout(id)
    get_stats_by_team(id).games.map(&:score_difference).max
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
    opponent = get_stats_by_team(id).opponents
      .min_by do |opponent_id|
        average_win_percentage_against_team(opponent_id, id)
      end
    opponent_team = get_stats_by_team(opponent)
    opponent_team.team.name
  end

  def fewest_goals_scored(id)
    get_stats_by_team(id).all_goals_scored.min
  end

  def game_teams
    game_teams_repo.records
  end

  def games
    games_repo.records
  end

  def head_to_head(id)
    get_stats_by_team(id).opponents
      .each_with_object({}) do |opponent, hash|
        opp = get_stats_by_team(opponent).team
        name = opp.name
        opponent_id = opp.id
        hash[name] = average_win_percentage_against_team(id, opponent_id)
      end
  end

  def highest_scoring_visitor
    team = teams.max_by do |t|
      team_game_stats = TeamGameStats.new(team: t, games: t.games)
      team_game_stats.average_visiting_score
    end

    team.name
  end

  def highest_total_score
    games.map(&:total_score).max
  end

  def lowest_scoring_home_team
    team = teams.min_by do |t|
      team_game_stats = TeamGameStats.new(team: t, games: t.games)
      team_game_stats.average_home_score
    end

    team.name
  end

  def lowest_total_score
    games.map(&:total_score).min
  end

  def most_goals_scored(id)
    get_stats_by_team(id).all_goals_scored.max
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

  def rival(id)
    opponent = get_stats_by_team(id).opponents
      .max_by do |opponent_id|
        average_win_percentage_against_team(opponent_id, id)
      end
    get_stats_by_team(opponent).team.name
  end

  def seasonal_summary(id)
    this_team = get_stats_by_team(id)
    seasons = games.map(&:season).uniq
    season_types = games.map(&:season_type).uniq
    seasons.each_with_object({}) do |season, hash|
      hash[season] = season_types.each_with_object({}) do |type, hash_2|
        hash_2[type] = this_team.season_information(season, type)
      end
    end
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
    team = teams.max_by do |t|
      team_game_stats = TeamGameStats.new(team: t, games: t.games)
      percentage(team_game_stats.number_of_wins, t.games.size)
    end

    team.name
  end

  def winningest_coach(season)
    coach_season_games = game_teams.group_by do |game_team|
      game_season = games.find { |game| game.id == game_team.game_id}
                    &.season

      if game_season == season
        game_team.head_coach
      else
        ""
      end
    end
    coach_season_games.delete("")

    coach_season_games.keys.max_by do |coach|
      coach_season_games[coach].inject(0) do |sum, game_team|
        if game_team.result == "LOSS"
          0
        else
          sum + 1
        end
      end.to_f / coach_season_games[coach].size
    end
  end

  def winningest_coach(season)
    coach_games = coach_season_games(season)
    coach_games.keys.max_by do |coach|
      coach_games[coach].inject(0) do |sum, game_team|
        if game_team.result == "LOSS"
          0
        else
          sum + 1
        end
      end.to_f / coach_games[coach].size
    end
  end

  def worst_coach(season)
    coach_games = coach_season_games(season)
    coach_games.keys.min_by do |coach|
      coach_games[coach].inject(0) do |sum, game_team|
        if game_team.result == "LOSS"
          0
        else
          sum + 1
        end
      end.to_f / coach_games[coach].size
    end
  end

  def worst_defense
    team = teams.max_by do |t|
      team_game_stats = TeamGameStats.new(team: t, games: t.games)
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
    team = teams.min_by do |t|
      team_game_stats = TeamGameStats.new(team: t, games: t.games)
      team_game_stats.average_score
    end

    team.name
  end

  def worst_lost(id)
    get_stats_by_team(id).games.map(&:score_difference).min
  end

  def worst_season(id)
    get_stats_by_team(id).number_lost_by_season
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

  def coach_season_games(season)
    coach_games = game_teams.group_by do |game_team|
      game_season = games.find { |game| game.id == game_team.game_id}
                    &.season

      if game_season == season
        game_team.head_coach
      else
        ""
      end
    end
    coach_games.delete("")
    return coach_games
  end

  def find_games_from_season(season)
    games.select do |game|
      game.season == season
    end
  end

  def find_team_row(id)
    teams.detect do |team|
      team.id == id
    end
  end

  def get_stats_by_team(id)
    this_team = find_team_row(id)
    TeamGameStats.new(team: this_team, games: this_team.games)
  end

  def percentage(dividend, divisor)
    return 0 if divisor.zero?

    ((dividend / divisor.to_f) * 100).round(3)
  end
end
