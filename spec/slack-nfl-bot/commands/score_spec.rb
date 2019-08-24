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

    slack_message = "Latest scores:\nJacksonville Jaguars (10)\n\n*Philadelphia Eagles* (24)\n\nFINAL\n\nAtlanta Falcons (10)\n\n*New York Jets* (22)\n\nFINAL\n\n*Cincinnati Bengals*\n*New York Giants*\nFriday, 00:00:00 BST\n\n*Atlanta Falcons*\n*Washington Redskins*\nFriday, 00:30:00 BST\n"
    expect(message: "nflbot scores", channel: 'channel').to respond_with_slack_message(slack_message)
  end

  context "it returns the latest score for your assigned team" do
    it "with a question mark" do
      expect(Week).to receive(:json_endpoint).and_return(scores_url)
      expect(::Team).to receive(:get_team).and_return("Washington Redskins")

      slack_message = "*Atlanta Falcons*\n*Washington Redskins*\nFriday, 00:30:00 BST\n"
      expect(message: "nflbot how did my team do?", channel: 'channel').to respond_with_slack_message(slack_message)
    end

    it "without a question mark" do
      expect(Week).to receive(:json_endpoint).and_return(scores_url)
      expect(::Team).to receive(:get_team).and_return("Washington Redskins")

      slack_message = "*Atlanta Falcons*\n*Washington Redskins*\nFriday, 00:30:00 BST\n"
      expect(message: "nflbot how did my team do", channel: 'channel').to respond_with_slack_message(slack_message)
    end
  end

  it "returns a message if your team didn't play" do
    expect(Week).to receive(:json_endpoint).and_return(scores_url)
    expect(::Team).to receive(:get_team).and_return("Cleveland Browns")

    slack_message = "Looks like your team didn't play this week"
    expect(message: "nflbot how'd my team do?", channel: 'channel').to respond_with_slack_message(slack_message)
  end
end
