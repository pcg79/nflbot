require 'spec_helper'

describe SlackNFLBot::Commands::Team, vcr: { cassette_name: 'team_commands' } do
  def app
    SlackNFLBot::App.new
  end

  it "assigns a random team if none assigned" do
    expect(SlackNFLBot::Commands::Team).to receive(:slack_user_id).and_return(1)

    slack_message = "<@user>, your team is the *Washington Redskins*"
    expect(message: "nflbot what's my team", channel: 'channel').to respond_with_slack_message(slack_message)
  end

  it "returns a team if already assigned" do
    expect(::Team).to receive(:find_team_by_slack_user_id).and_return("Washington Redskins")

    slack_message = "<@user>, your team is the *Washington Redskins*"
    expect(message: "nflbot what's my team", channel: 'channel').to respond_with_slack_message(slack_message)
  end

end
