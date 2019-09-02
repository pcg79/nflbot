require 'spec_helper'

describe SlackNFLBot::Commands::Assignment do
  def app
    SlackNFLBot::App.new
  end

  it "returns who was assigned which team" do
    slack_message = "Atlanta Falcons: <@3>\nWashington Redskins: <@1>,<@2>"
    expect(message: "nflbot assignments", channel: 'channel').to respond_with_slack_message(slack_message)
  end

end
