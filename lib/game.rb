class Game
  def initialize(attributes)
    @attributes = attributes
  end

  def game_id
    @attributes[:game_id].to_i
  end

  def season
    @attributes[:season]
  end

  def type
    @attributes[:type]
  end

  def date_time
    @attributes[:date_time]
  end

  def away_team_id
    @attributes[:away_team_id].to_i
  end

  def home_team_id
    @attributes[:home_team_id].to_i
  end

  def away_goals
    @attributes[:away_goals].to_i
  end

  def home_goals
    @attributes[:home_goals].to_i
  end

  def venue
    @attributes[:venue]
  end

  def venue_link
    @attributes[:venue_link]
  end

  def total_score
    away_goals + home_goals
  end

  def score_difference
    home_goals - away_goals
  end
end
