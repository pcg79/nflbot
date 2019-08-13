require 'spec_helper'

describe SlackNFLBot::Commands::NFLBot, vcr: { cassette_name: 'nfl_commands' } do
  def app
    SlackNFLBot::App.new
  end

  it "assigns a team" do
    expect(message: "nflbot what's my team", channel: 'channel').to respond_with_slack_message('4')
  end

end
