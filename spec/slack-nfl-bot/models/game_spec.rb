require 'spec_helper'

describe Game do
  subject(:game) { described_class.new({
      week: 2,
      home_team: "Washington Redskins",
      away_team: "New England Patriots",
      game_iso_time: 1565910000000,
      phase: "FINAL",
      home_team_score: "21",
      away_team_score: "0"
    })
  }

  context "#has_team?" do
    it "returns true if the game had the team as the home team" do
      expect(game.has_team?("Washington Redskins")).to be_truthy
    end

    it "returns true if the game had the team as the visiting team" do
      expect(game.has_team?("New England Patriots")).to be_truthy
    end

    it "returns false if the game didn't have the team as either participant" do
      expect(game.has_team?("Cleveland Browns")).to be_falsy
    end
  end

end
