require 'spec_helper'

describe SlackNFLBot::Commands::Ping, vcr: { cassette_name: 'ping_commands' } do
  def app
    SlackNFLBot::App.new
  end

  it "assigns a team" do
    expect(message: "nflbot ping", channel: "channel").to respond_with_slack_message("<@user> - pong")
  end

end
