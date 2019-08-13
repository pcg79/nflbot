require 'spec_helper'

describe SlackNFLBot::Commands::Fact, vcr: { cassette_name: 'fact_commands' } do
  def app
    SlackNFLBot::App.new
  end

  it "returns a fact about your assigned team" do
    expect(::Team).to receive(:find_team_by_slack_user_id).and_return(["Washington Redskins"])
    expect(::Fact).to receive(:find_facts).and_return(["Fun fact!"])

    slack_message = "Here's a fun fact about the *Washington Redskins*: Fun fact!"
    expect(message: "nflbot what is a fact about my team", channel: 'channel').to respond_with_slack_message(slack_message)
  end

  it "returns a fact about a specified team " do
    expect(::Fact).to receive(:find_facts).and_return(["Fun fact!"])

    slack_message = "Here's a fun fact about the *Washington Redskins*: Fun fact!"
    expect(message: "nflbot what is a fact about the Washington Redskins?", channel: 'channel').to respond_with_slack_message(slack_message)
  end

end
