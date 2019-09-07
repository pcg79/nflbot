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

  def game_not_yet_played_highlights_url
    File.join(File.dirname(__FILE__), "..", "..", "fixtures", "nfl_game_highlights_by_game_2019090901.json")
  end

  let(:bears) {
    Team.new({
      full_name: "Chicago Bears",
    })
  }

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

      # Double \\ are so the * are escaped in the regex
      message = "Here are the highlights for the \\*Washington Redskins AT Atlanta Falcons\\* game:"

      expect(message: "nflbot highlights", channel: "channel").to respond_with_slack_message(/#{message}/)
    end

    it "states when there are no highlights for your team yet" do
      expect(::Team).to receive(:get_team).and_return(redskins)
      expect(::Week).to receive(:json_endpoint).and_return(scores_url)
      expect_any_instance_of(::Game).to receive(:highlights_endpoint).and_return(game_not_yet_played_highlights_url)

      message = "Highlights for \*Washington Redskins AT Atlanta Falcons\* are not yet available"

      expect(message: "nflbot highlights", channel: "channel").to respond_with_slack_message(message)
    end

    it "states when the team didn't play that week" do
      expect(::Team).to receive(:get_team).and_return(bears)
      expect(::Week).to receive(:json_endpoint).and_return(scores_url)
      expect_any_instance_of(::Game).to receive(:highlights_endpoint).never

      message = "Looks like your team didn't play in week 2"

      expect(message: "nflbot highlights", channel: "channel").to respond_with_slack_message(/#{message}/)
    end
  end

  context "highlights for any team" do
    it "returns the highlight videos for that team's game" do
      expect(::Team).to receive(:get_team).and_return(bears)
      expect(::Week).to receive(:json_endpoint).and_return(scores_url)
      expect_any_instance_of(::Game).to receive(:highlights_endpoint).and_return(highlights_url)

      # Double \\ are so the * are escaped in the regex
      message = "Here are the highlights for the \\*Washington Redskins AT Atlanta Falcons\\* game:"

      expect(message: "nflbot highlights for the Chicago Bears", channel: "channel").to respond_with_slack_message(/#{message}/)
    end
  end
end
