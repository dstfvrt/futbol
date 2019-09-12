require "./lib/game_teams"

RSpec.describe GameTeams do
  raw_attributes = {
    game_id: "2012030221",
    team_id: "3",
    HoA: "away",
    result: "LOSS",
    settled_in: "OT",
    head_coach: "John Tortorella",
    goals: "2",
    shots: "8",
    tackles: "44",
    pim: "8",
    powerPlayOpportunities: "3",
    powerPlayGoals: "0",
    faceOffWinPercentage: "44.8",
    giveaways: "17",
    takeaways: "7",
  }

  describe "#initialize" do
    it "takes a hash and contains values" do
      game_teams = GameTeams.new(raw_attributes)
      expect(game_teams.game_id).to eq 2012030221
      expect(game_teams.team_id).to eq 3
      expect(game_teams.hoa).to eq "away"
      expect(game_teams.result).to eq "LOSS"
      expect(game_teams.settled_in).to eq "OT"
      expect(game_teams.head_coach).to eq "John Tortorella"
      expect(game_teams.goals).to eq 2
      expect(game_teams.shots).to eq 8
      expect(game_teams.tackles).to eq 44
      expect(game_teams.pim).to eq 8
      expect(game_teams.power_play_opportunities).to eq 3
      expect(game_teams.power_play_goals).to eq 0
      expect(game_teams.face_off_win_percentage).to eq 44.8
      expect(game_teams.giveaways).to eq 17
      expect(game_teams.takeaways).to eq 7
    end
  end
end
