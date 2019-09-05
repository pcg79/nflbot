require 'spec_helper'

describe SlackNFLBot::Commands::Score do
  def app
    SlackNFLBot::App.new
  end

  def scores_url
    File.join(File.dirname(__FILE__), "..", "..", "fixtures", "nfl_scores.json")
  end

  let(:redskins) {
    Team.new({
      full_name: "Washington Redskins",
    })
  }
  let(:browns) {
    Team.new({
      full_name: "Cleveland Browns",
    })
  }
  let(:eagles) {
    Team.new({
      full_name: "Philadelphia Eagles",
    })
  }

  it "returns the latest score for all teams" do
    expect(::Week).to receive(:json_endpoint).and_return(scores_url)
    expect_any_instance_of(SlackNFLBot::SlackClient).to receive(:real_name).and_return("Pat", "Ethan", "Kalani", "Joy")

    slack_message = "Week 2 scores:\n*Philadelphia Eagles (24)*\nJacksonville Jaguars (10)\nFINAL\n\n*New York Jets (22)*\nAtlanta Falcons (Pat) (10)\nFINAL\n\nNew York Giants\nCincinnati Bengals\nFriday, 00:00:00 BST\n\nWashington Redskins (Ethan, Kalani)\nAtlanta Falcons (Joy)\nFriday, 00:30:00 BST"
    expect(message: "nflbot scores", channel: 'channel').to respond_with_slack_message(slack_message)
  end

  context "it returns when your team will play if they haven't played in that week yet" do
    it "with a question mark" do
      expect(Week).to receive(:json_endpoint).and_return(scores_url)
      expect(::Team).to receive(:get_team).and_return(redskins)
      expect_any_instance_of(SlackNFLBot::SlackClient).to receive(:real_name).and_return("Pat", "Ethan", "Kalani")

      slack_message = "Week 2\nWashington Redskins (Pat, Ethan)\nAtlanta Falcons (Kalani)\nFriday, 00:30:00 BST"
      expect(message: "nflbot how did my team do?", channel: 'channel').to respond_with_slack_message(slack_message)
    end

    it "without a question mark" do
      expect(Week).to receive(:json_endpoint).and_return(scores_url)
      expect(::Team).to receive(:get_team).and_return(redskins)
      expect_any_instance_of(SlackNFLBot::SlackClient).to receive(:real_name).and_return("Pat", "Ethan", "Kalani")

      slack_message = "Week 2\nWashington Redskins (Pat, Ethan)\nAtlanta Falcons (Kalani)\nFriday, 00:30:00 BST"
      expect(message: "nflbot how did my team do", channel: 'channel').to respond_with_slack_message(slack_message)
    end
  end

  context "it returns the score from your team's game if they played already" do
    it "with a question mark" do
      expect(Week).to receive(:json_endpoint).and_return(scores_url)
      expect(::Team).to receive(:get_team).and_return(eagles)

      slack_message = "Week 2\n*Philadelphia Eagles (24)*\nJacksonville Jaguars (10)\nFINAL"
      expect(message: "nflbot how did my team do?", channel: 'channel').to respond_with_slack_message(slack_message)
    end

    it "without a question mark" do
      expect(Week).to receive(:json_endpoint).and_return(scores_url)
      expect(::Team).to receive(:get_team).and_return(redskins)
      expect_any_instance_of(SlackNFLBot::SlackClient).to receive(:real_name).and_return("Pat", "Ethan", "Kalani")

      slack_message = "Week 2\nWashington Redskins (Pat, Ethan)\nAtlanta Falcons (Kalani)\nFriday, 00:30:00 BST"
      expect(message: "nflbot how did my team do", channel: 'channel').to respond_with_slack_message(slack_message)
    end
  end


  context "returns a message if your team didn't play" do
    it "with a contraction" do
      expect(Week).to receive(:json_endpoint).and_return(scores_url)
      expect(::Team).to receive(:get_team).and_return(browns)

      slack_message = "Looks like your team didn't play in week 2"
      expect(message: "nflbot how'd my team do?", channel: 'channel').to respond_with_slack_message(slack_message)
    end

    it "with bad grammar" do
      expect(Week).to receive(:json_endpoint).and_return(scores_url)
      expect(::Team).to receive(:get_team).and_return(browns)

      slack_message = "Looks like your team didn't play in week 2"
      expect(message: "nflbot howd my team do?", channel: 'channel').to respond_with_slack_message(slack_message)
    end
  end
end
