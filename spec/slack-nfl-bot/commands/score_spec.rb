require 'spec_helper'

describe SlackNFLBot::Commands::Score, vcr: { cassette_name: 'fact_commands' } do
  def app
    SlackNFLBot::App.new
  end

  def scores_url
    File.join(File.dirname(__FILE__), "..", "..", "fixtures", "nfl_scores.xml")
  end

  it "returns the latest score for all teams" do
    expect(Week).to receive(:scores_url).and_return(scores_url)

    slack_message = "Latest scores:\nBAL Ravens (26) BEAT GB Packers (13)\nJAX Jaguars (10) LOST TO PHI Eagles (24)\nATL Falcons (10) LOST TO NYJ Jets (13) in overtime\nARI Cardinals (26) TIED OAK Raiders (26)\nDEN Broncos will play SF 49ers on Mon at 8:00"
    expect(message: "nflbot scores", channel: 'channel').to respond_with_slack_message(slack_message)
  end

  # context "it returns the latest score for your assigned team" do
  #   it "with a question mark" do
  #     expect(::Team).to receive(:find_team_by_slack_user_id).and_return("Washington Redskins")

  #     slack_message = "Here's a fun fact about the *Washington Redskins*: Redskins fact!"
  #     expect(message: "nflbot what is a fact about my team?", channel: 'channel').to respond_with_slack_message(slack_message)
  #   end

  #   it "without a question mark" do
  #     expect(::Team).to receive(:find_team_by_slack_user_id).and_return("Washington Redskins")

  #     slack_message = "Here's a fun fact about the *Washington Redskins*: Redskins fact!"
  #     expect(message: "nflbot what is a fact about my team", channel: 'channel').to respond_with_slack_message(slack_message)
  #   end
  # end

  # context "returns a fact about a specified team" do
  #   it "with a question mark" do
  #     slack_message = "Here's a fun fact about the *Washington Redskins*: Redskins fact!"
  #     expect(message: "nflbot what is a fact about the Washington Redskins?", channel: 'channel').to respond_with_slack_message(slack_message)
  #   end

  #   it "without a question mark" do
  #     slack_message = "Here's a fun fact about the *Washington Redskins*: Redskins fact!"
  #     expect(message: "nflbot what is a fact about the Washington Redskins", channel: 'channel').to respond_with_slack_message(slack_message)
  #   end
  # end

  # it "states when it can't find a fact for a team" do
  #   slack_message = "I don't have any facts about the *New England Patriots* :cry:"
  #   expect(message: "nflbot what is a fact about the New England Patriots", channel: 'channel').to respond_with_slack_message(slack_message)
  # end
end
