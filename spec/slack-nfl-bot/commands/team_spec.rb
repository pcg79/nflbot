require 'spec_helper'

describe SlackNFLBot::Commands::Team, vcr: { cassette_name: 'team_commands' } do
  def app
    SlackNFLBot::App.new
  end

  it "assigns a team" do
    expect(SlackNFLBot::Commands::Team).to receive(:find_team_by_slack_user_id).and_return(["Washington Redskins"])

    slack_message = "<@user>, your team is the *Washington Redskins*"
    expect(message: "nflbot what's my team", channel: 'channel').to respond_with_slack_message(slack_message)
  end

end