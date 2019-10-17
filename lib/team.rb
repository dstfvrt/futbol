class Team
  attr_reader :tracker

  def initialize(attributes)
    @attributes = attributes
    @tracker = tracker
  end

  def abbreviation
    @attributes[:abbreviation]
  end

  def average_score(games)
    average_home_scores(games) + average_away_scores(games)
  end

  def average_away_scores(games)
    away_scores(games).reduce(:+) / away_scores(games).size
  end

  def average_home_scores(games)
    home_scores(games).reduce(:+) / home_scores(games).size
  end

<<<<<<< Updated upstream
  def away_scores(games)
    games.select { |game| game.away_team_id == team_id }
      .map { |game| game.away_goals }
  end

  def blocked_home_shots(games, game_teams)
    game_teams.select do |game_team|
      games.map { |game| game.game_id unless game.home_team_id != team_id }
        .contains(game_team.game_id)
=======
  def away_games(games)
    games.select { |game| game.away_team_id == team_id }
  end

  def blocked_home_shots(games, game_teams)
    games.select { |game| game.home_team_id == team_id }
>>>>>>> Stashed changes
  end

  def franchise_id
    @attributes[:franchiseId].to_i
  end

<<<<<<< Updated upstream
  def home_scores(games)
    games.select { |game| game.home_team_id == team_id }
      .map { |game| game.home_goals }
=======
  def home_games(games)
    games.select { |game| game.home_team_id == team_id }
>>>>>>> Stashed changes
  end

  def link
    @attributes[:link]
  end

  def stadium
    @attributes[:Stadium]
  end

  def team_id
    @attributes[:team_id].to_i
  end

  def team_name
    @attributes[:teamName]
  end
end
