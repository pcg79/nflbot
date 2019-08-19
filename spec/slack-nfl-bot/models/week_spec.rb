require 'spec_helper'

describe Week do
  let(:game) { Game.new({
      week: 2,
      home_team: "Washington Redskins",
      away_team: "New England Patriots",
      game_day: "Sun",
      game_time: "16:00",
      status: "FINAL",
      home_team_score: "21",
      away_team_score: "0"
    })
  }

  subject(:week) do
    expect_any_instance_of(Week).to receive(:parse_games).and_return([game])

    described_class.new
  end

  context "#find_game_by_team" do
    it "returns a game if the team is one of the participants" do
      expect(week.find_game_by_team("Washington Redskins")).to eq game
    end

    it "returns nil if no games had the team as a participant" do
      expect(week.find_game_by_team("Cleveland Browns")).to be_nil
    end
  end

  context "#current_week" do
    it "returns an instance with the current week info" do
      expect_any_instance_of(Week).to receive(:parse_games).and_return([game])

      expect(Week.current_week).to be_an_instance_of Week
    end
  end

end
