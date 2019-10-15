class Team
  def initialize(attributes)
    @attributes = attributes
  end

  def abbreviation
    @attributes[:abbreviation]
  end

  def average_score(games)
    home_scores(games) + away_scores(games)
  end

  def away_scores(games)
    games.select { |game| game.away_team_id == team_id}
    .map { |game| game.away_goals }
  end

  def franchise_id
    @attributes[:franchiseId].to_i
  end

  def home_scores(games)
    games.select { |game| game.home_team_id == team_id}
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
