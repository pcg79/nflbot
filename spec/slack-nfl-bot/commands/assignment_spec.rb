require 'spec_helper'

describe SlackNFLBot::Commands::Assignment do
  def app
    SlackNFLBot::App.new
  end

  it "returns who was assigned which team" do
    expect_any_instance_of(SlackNFLBot::SlackClient).to receive(:real_name).and_return("Pat", "Ethan", "Kalani")

    slack_message = "*Atlanta Falcons*: Pat\n*Washington Redskins*: Ethan, Kalani"
    expect(message: "nflbot assignments", channel: 'channel').to respond_with_slack_message(slack_message)
  end

end
