require 'spec_helper'

describe SlackNFLBot::Commands::Score do
  def app
    SlackNFLBot::App.new
  end

  def scores_url
    File.join(File.dirname(__FILE__), "..", "..", "fixtures", "nfl_scores.json")
  end

  it "returns the latest score for all teams" do
    expect(::Week).to receive(:json_endpoint).and_return(scores_url)

    slack_message = "Week 2 scores:\n*Philadelphia Eagles (24)*\nJacksonville Jaguars (10)\nFINAL\n\n*New York Jets (22)*\nAtlanta Falcons (10)\nFINAL\n\nNew York Giants\nCincinnati Bengals\nFriday, 00:00:00 BST\n\nWashington Redskins\nAtlanta Falcons\nFriday, 00:30:00 BST"
    expect(message: "nflbot scores", channel: 'channel').to respond_with_slack_message(slack_message)
  end

  context "it returns the latest score for your assigned team" do
    it "with a question mark" do
      expect(Week).to receive(:json_endpoint).and_return(scores_url)
      expect(::Team).to receive(:get_team).and_return("Washington Redskins")

      slack_message = "Week 2\nWashington Redskins\nAtlanta Falcons\nFriday, 00:30:00 BST"
      expect(message: "nflbot how did my team do?", channel: 'channel').to respond_with_slack_message(slack_message)
    end

    it "without a question mark" do
      expect(Week).to receive(:json_endpoint).and_return(scores_url)
      expect(::Team).to receive(:get_team).and_return("Washington Redskins")

      slack_message = "Week 2\nWashington Redskins\nAtlanta Falcons\nFriday, 00:30:00 BST"
      expect(message: "nflbot how did my team do", channel: 'channel').to respond_with_slack_message(slack_message)
    end
  end

  context "returns a message if your team didn't play" do
    it "with a contraction" do
      expect(Week).to receive(:json_endpoint).and_return(scores_url)
      expect(::Team).to receive(:get_team).and_return("Cleveland Browns")

      slack_message = "Looks like your team didn't play in week 2"
      expect(message: "nflbot how'd my team do?", channel: 'channel').to respond_with_slack_message(slack_message)
    end

    it "with bad grammar" do
      expect(Week).to receive(:json_endpoint).and_return(scores_url)
      expect(::Team).to receive(:get_team).and_return("Cleveland Browns")

      slack_message = "Looks like your team didn't play in week 2"
      expect(message: "nflbot howd my team do?", channel: 'channel').to respond_with_slack_message(slack_message)
    end
  end
end
