require "stat_tracker"

RSpec.describe StatTracker do
  let (:stat_tracker) { build_stat_tracker }

  describe "#team_info" do
    it "returns a hash with team info" do
      team = [
        instance_double(Team, {
          id: 1,
          franchise_id: 23,
          name: "Team",
          abbreviation: "tm",
          link: "link",
        }),
      ]

      allow(stat_tracker)
        .to receive(:teams)
        .and_return(team)

      team_hash = {
        "team_id" => 1,
        "franchise_id" => 23,
        "team_name" => "Team",
        "abbreviation" => "tm",
        "link" => "link",
      }
      expect(stat_tracker.team_info(1)).to eq(team_hash)
    end
  end

  describe "#best_season" do
    it "returns season with the highest win percentage for a team" do
      united_id = 6
      expect(stat_tracker.best_season(united_id)).to eq("20122013")
    end
  end

  describe "#worst_season" do
    it "returns season with the lowest win percentage for a team" do
      united_id = 6
      expect(stat_tracker.worst_season(united_id)).to eq("20122013")
    end
  end

  describe "#average_win_percentage" do
    it "returns average win percentage of all games for a team" do
      united_id = 6
      expect(stat_tracker.average_win_percentage(united_id)).to eq(75.00)
    end
  end

  describe "#average_win_percentage_against_team" do
    xit "returns average win percentage of all games for a team" do
      expect(stat_tracker.average_win_percentage_against_team(6, 3))
        .to eq(60.00)
    end
  end

  describe "#most_goals_scored" do
    it "returns the highest numbers of goals a team scored in a single game" do
      united_id = 6

      expect(stat_tracker.most_goals_scored(united_id)).to eq(4)
    end
  end

  describe "#fewest_goals_scored" do
    it "returns the highest numbers of goals a team scored in a single game" do
      united_id = 6

      expect(stat_tracker.fewest_goals_scored(united_id)).to eq(0)
    end
  end

  describe "#favorite_opponent" do
    xit "returns the opponent that has the lowest win % against a team" do
      united_id = 6

      expect(stat_tracker.favorite_opponent(united_id)).to eq("Fire")
    end
  end

  describe "#rival" do
    xit "returns the opponent that has the highest win % against a team" do
    end
  end

  describe "#biggest_team_blowout" do
    xit "returns biggest difference between team & oppenent goals for a win" do
      united_id = 6

      expect(stat_tracker.biggest_team_blowout(united_id)).to eq(1)
    end
  end

  describe "#worst_loss" do
    xit "returns biggest difference between team & oppenent goals for a loss" do
    end
  end
end
