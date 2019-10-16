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

  def away_scores(games)
    games.select { |game| game.away_team_id == team_id}
    .map { |game| game.away_goals }
  end

  def franchise_id
    @attributes[:franchiseId].to_i
  end

  def home_scores(games)
    home_scores = games.select { |game| game.home_team_id == team_id}
    .map { |game| game.home_goals }
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
