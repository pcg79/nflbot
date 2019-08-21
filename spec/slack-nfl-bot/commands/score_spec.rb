require 'spec_helper'

describe SlackNFLBot::Commands::Score do
  def app
    SlackNFLBot::App.new
  end

  def scores_url
    File.join(File.dirname(__FILE__), "..", "..", "fixtures", "nfl_feed_scores.xml")
  end

  it "returns the latest score for all teams" do
    expect(::Week).to receive(:endpoint).and_return(scores_url)

    slack_message = "Latest scores:\n*Carolina Panthers* will play *Buffalo Bills* on Friday at 16:00:00 \n*Baltimore Ravens* (26) BEAT *Green Bay Packers* (13)\n*Washington Redskins* (13) LOST TO *Cincinnati Bengals* (23)\n*Arizona Cardinals* (33) TIED *Oakland Raiders* (33)"
    expect(message: "nflbot scores", channel: 'channel').to respond_with_slack_message(slack_message)
  end

  context "it returns the latest score for your assigned team" do
    it "with a question mark" do
      expect(Week).to receive(:endpoint).and_return(scores_url)
      expect(::Team).to receive(:get_team).and_return("Washington Redskins")

      slack_message = "*Washington Redskins* (13) LOST TO *Cincinnati Bengals* (23)"
      expect(message: "nflbot how did my team do?", channel: 'channel').to respond_with_slack_message(slack_message)
    end

    it "without a question mark" do
      expect(Week).to receive(:endpoint).and_return(scores_url)
      expect(::Team).to receive(:get_team).and_return("Washington Redskins")

      slack_message = "*Washington Redskins* (13) LOST TO *Cincinnati Bengals* (23)"
      expect(message: "nflbot how did my team do", channel: 'channel').to respond_with_slack_message(slack_message)
    end
  end

  it "returns a message if your team didn't play" do
    expect(Week).to receive(:endpoint).and_return(scores_url)
    expect(::Team).to receive(:get_team).and_return("Cleveland Browns")

    slack_message = "Looks like your team didn't play this week"
    expect(message: "nflbot how'd my team do?", channel: 'channel').to respond_with_slack_message(slack_message)
  end
end
