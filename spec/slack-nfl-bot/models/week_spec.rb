require 'spec_helper'

def scores_url
  File.join(File.dirname(__FILE__), "..", "..", "fixtures", "nfl_scores.json")
end

describe Week do
  subject(:week) do
    described_class.new
  end

  let(:games_data) { JSON.load(File.open(scores_url)) }

  context "#find_game_by_team" do
    it "returns a game if the team is one of the participants" do
      expect_any_instance_of(Week).to receive(:games_data).and_return(games_data)

      expect(week.find_game_by_team("Washington Redskins").away_team).to eq "Washington Redskins"
    end

    it "returns nil if no games had the team as a participant" do
      expect_any_instance_of(Week).to receive(:games_data).and_return(games_data)

      expect(week.find_game_by_team("Cleveland Browns")).to be_nil
    end
  end

  context "#current_week" do
    it "returns an instance with the current week info" do
      expect_any_instance_of(Week).to receive(:games_data).and_return(games_data)

      expect(week).to be_an_instance_of Week
      expect(week.season).to eq 2019
      expect(week.season_type).to eq "PRE"
      expect(week.week_number).to eq 2
      expect(week.games.count).to eq 4
    end
  end

end
