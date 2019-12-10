require "stat_tracker"

RSpec.describe StatTracker do
  let (:stat_tracker) { build_stat_tracker }

  describe "#average_win_percentage" do
    it "returns average win percentage of all games for a team" do
      united_id = 6
      expect(stat_tracker.average_win_percentage(united_id)).to eq(75.00)
    end
  end

  describe "#average_win_percentage_against_team" do
    it "returns average win percentage of all games for a team" do
      expect(stat_tracker.average_win_percentage_against_team(16, 17))
        .to eq(42.857)
    end
  end

  describe "#best_season" do
    it "returns season with the highest win percentage for a team" do
      united_id = 6
      expect(stat_tracker.best_season(united_id)).to eq("20122013")
    end
  end

  describe "#biggest_team_blowout" do
    it "returns biggest difference between team & oppenent goals for a win" do
      united_id = 6

      expect(stat_tracker.biggest_team_blowout(united_id)).to eq(2)
    end
  end

  describe "#favorite_opponent" do
    it "returns the opponent that has the lowest win % against a team" do
      united_id = 6

      expect(stat_tracker.favorite_opponent(united_id)).to eq("Houston Dynamo")
    end
  end

  describe "#fewest_goals_scored" do
    it "returns the highest numbers of goals a team scored in a single game" do
      united_id = 6

      expect(stat_tracker.fewest_goals_scored(united_id)).to eq(0)
    end
  end

  describe "#head_to_head" do
    it "returns record against all opponents with win percentage" do
      united_id = 6

      record_hash = {
        "Houston Dynamo" => 100.0,
        "Sporting Kansas City" => 57.143,
      }
      expect(stat_tracker.head_to_head(united_id)).to eq record_hash
    end
  end

  describe "#most_goals_scored" do
    it "returns the highest numbers of goals a team scored in a single game" do
      united_id = 6

      expect(stat_tracker.most_goals_scored(united_id)).to eq(4)
    end
  end

  describe "#rival" do
    it "returns the opponent that has the highest win % against a team" do
      united_id = 6
      opponent = "Sporting Kansas City"
      expect(stat_tracker.rival(united_id)).to eq(opponent)
    end
  end
  describe "#seasonal_summary" do
    it "returns each season and information for that season" do
      united_id = 6

      seasonal_hash = {
        "20122013" => {
          regular_season: {
            win_percentage: 0.00,
            total_goals_scored: 0,
            total_goals_against: 1,
            average_goals_scored: 0.0,
            average_goals_against: 1.0,
          },
          post_season: {
            win_percentage: 100.00,
            total_goals_scored: 24,
            total_goals_against: 10,
            average_goals_scored: 2.67,
            average_goals_against: 1.11,
          },
        },
        "20132014" => {
          regular_season: {
            win_percentage: 0.0,
            total_goals_scored: 0,
            total_goals_against: 2,
            average_goals_scored: 0.0,
            average_goals_against: 1.0,
          },
          post_season: {
            win_percentage: 0.0,
            total_goals_scored: 0,
            total_goals_against: 0,
            average_goals_scored: 0.0,
            average_goals_against: 0.0,
          },
        },
      }

      expect(stat_tracker.seasonal_summary(united_id)).to eq seasonal_hash
    end
  end

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

  describe "#worst_loss" do
    it "returns biggest difference between team & oppenent goals for a loss" do
      united_id = 6

      expect(stat_tracker.worst_lost(united_id)).to eq(-3)
    end
  end

  describe "#worst_season" do
    it "returns season with the lowest win percentage for a team" do
      united_id = 6
      expect(stat_tracker.worst_season(united_id)).to eq("20132014")
    end
  end
end
