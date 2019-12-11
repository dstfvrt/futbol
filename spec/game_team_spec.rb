require "./lib/game_team"

RSpec.describe GameTeam do
  let(:raw_attributes) do
    {
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
  end

  describe "#initialize" do
    it "takes a hash and contains values" do
      game_team = build_game_team
      expect(game_team.game_id).to eq 2012030221
      expect(game_team.team_id).to eq 3
      expect(game_team.hoa).to eq "away"
      expect(game_team.result).to eq "LOSS"
      expect(game_team.settled_in).to eq "OT"
      expect(game_team.head_coach).to eq "John Tortorella"
      expect(game_team.goals).to eq 2
      expect(game_team.shots).to eq 8
      expect(game_team.shots_to_goals_ratio).to eq 4
      expect(game_team.tackles).to eq 44
      expect(game_team.pim).to eq 8
      expect(game_team.power_play_opportunities).to eq 3
      expect(game_team.power_play_goals).to eq 0
      expect(game_team.face_off_win_percentage).to eq 44.8
      expect(game_team.giveaways).to eq 17
      expect(game_team.takeaways).to eq 7
    end
  end

  describe "#shots_to_goals_ratio" do
    context "if the number goals is zero" do
      it "returns the number of shots" do
        raw_attributes[:shots] = 6
        raw_attributes[:goals] = 0
        game_team = build_game_team

        expect(game_team.shots_to_goals_ratio).to eq 6
      end
    end

    context "if the number of goals is nonzero" do
      it "returns the number of shots divided by goals" do
        raw_attributes[:shots] = 6
        raw_attributes[:goals] = 4
        game_team = build_game_team

        expect(game_team.shots_to_goals_ratio).to eq 1.5

      end
    end
  end

  private

  def build_game_team
    GameTeam.new(raw_attributes)
  end
end
