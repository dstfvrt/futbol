require "./lib/record"

class GameTeam < Record
  def game_id
    attributes[:game_id].to_i
  end

  def team_id
    attributes[:team_id].to_i
  end

  def hoa
    attributes[:HoA]
  end

  def result
    attributes[:result]
  end

  def settled_in
    attributes[:settled_in]
  end

  def head_coach
    attributes[:head_coach]
  end

  def goals
    attributes[:goals].to_i
  end

  def shots
    attributes[:shots].to_i
  end

  def tackles
    attributes[:tackles].to_i
  end

  def pim
    attributes[:pim].to_i
  end

  def power_play_opportunities
    attributes[:powerPlayOpportunities].to_i
  end

  def power_play_goals
    attributes[:powerPlayGoals].to_i
  end

  def face_off_win_percentage
    attributes[:faceOffWinPercentage].to_f
  end

  def giveaways
    attributes[:giveaways].to_i
  end

  def takeaways
    attributes[:takeaways].to_i
  end
end
