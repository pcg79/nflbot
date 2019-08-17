require 'spec_helper'

describe SlackNFLBot::Commands::Fact, vcr: { cassette_name: 'fact_commands' } do
  def app
    SlackNFLBot::App.new
  end

  context "it returns a fact about your assigned team" do
    it "with a question mark" do
      expect(::Team).to receive(:get_team).and_return("Washington Redskins")

      slack_message = "Here's a fun fact about the *Washington Redskins*: Redskins fact!"
      expect(message: "nflbot what is a fact about my team?", channel: 'channel').to respond_with_slack_message(slack_message)
    end

    it "without a question mark" do
      expect(::Team).to receive(:get_team).and_return("Washington Redskins")

      slack_message = "Here's a fun fact about the *Washington Redskins*: Redskins fact!"
      expect(message: "nflbot what is a fact about my team", channel: 'channel').to respond_with_slack_message(slack_message)
    end
  end

  context "returns a fact about a specified team" do
    it "with a question mark" do
      slack_message = "Here's a fun fact about the *Washington Redskins*: Redskins fact!"
      expect(message: "nflbot what is a fact about the Washington Redskins?", channel: 'channel').to respond_with_slack_message(slack_message)
    end

    it "without a question mark" do
      slack_message = "Here's a fun fact about the *Washington Redskins*: Redskins fact!"
      expect(message: "nflbot what is a fact about the Washington Redskins", channel: 'channel').to respond_with_slack_message(slack_message)
    end
  end

  it "states when it can't find a fact for a team" do
    slack_message = "I don't have any facts about the *New England Patriots* :cry:"
    expect(message: "nflbot what is a fact about the New England Patriots", channel: 'channel').to respond_with_slack_message(slack_message)
  end

end
