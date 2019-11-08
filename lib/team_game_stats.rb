class TeamGameStats
  attr_reader :games, :team

  def initialize(team:, games:)
    @games = games
    @team = team
  end

  def average_allowed_goals
    number = games.sum do |game|
      if game.home_team_id == team.id
        game.away_goals
      else
        game.home_goals
      end
    end

    average(number, games.count)
  end

  private

  def average(dividend, divisor)
    return 0 if divisor.zero?

    dividend / divisor
  end
end
