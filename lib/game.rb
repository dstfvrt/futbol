require "./lib/record"

class Game < Record
  def away_goals
    attributes[:away_goals].to_i
  end

  def away_team_id
    attributes[:away_team_id].to_i
  end

  def away_win?
    home_goals < away_goals
  end

  def date_time
    attributes[:date_time]
  end

  def id
    attributes[:game_id].to_i
  end

  def has_team?(team_id)
    [home_team_id, away_team_id].include?(team_id)
  end

  def home_goals
    attributes[:home_goals].to_i
  end

  def home_team_id
    attributes[:home_team_id].to_i
  end

  def home_win?
    home_goals > away_goals
  end

  def losing_team_id
    if home_win?
      away_team_id
    else
      home_team_id
    end
  end

  def score_difference
    home_goals - away_goals
  end

  def season
    attributes[:season]
  end

  def season_type
    if type == "Regular Season"
      :regular_season
    elsif type == "Postseason"
      :post_season
    end
  end

  def tie?
    home_goals == away_goals
  end

  def total_score
    away_goals + home_goals
  end

  def type
    attributes[:type]
  end

  def venue
    attributes[:venue]
  end

  def venue_link
    attributes[:venue_link]
  end

  def winner?(team)
    if team.id == home_team_id
      home_win?
    elsif team.id == away_team_id
      away_win?
    else
      false
    end
  end

  def winning_team_id
    if home_win?
      home_team_id
    else
      away_team_id
    end
  end
end
