require 'spec_helper'

describe SlackNFLBot::Commands::Highlights do
  def app
    SlackNFLBot::App.new
  end

  def scores_url
    File.join(File.dirname(__FILE__), "..", "..", "fixtures", "nfl_scores.json")
  end

  def highlights_url
    File.join(File.dirname(__FILE__), "..", "..", "fixtures", "nfl_game_highlights_by_game_2019090500.json")
  end

  let(:redskins) {
    Team.new({
      full_name: "Washington Redskins",
    })
  }

  context "highlights for your team" do
    it "returns the highlight videos for that team's game" do
      expect(::Team).to receive(:get_team).and_return(redskins)
      expect(::Week).to receive(:json_endpoint).and_return(scores_url)
      expect_any_instance_of(::Game).to receive(:highlights_endpoint).and_return(highlights_url)


      message = "Here are the highlights for the.*game:"

      expect(message: "nflbot highlights", channel: "channel").to respond_with_slack_message(/#{message}/)
    end
  end
end
