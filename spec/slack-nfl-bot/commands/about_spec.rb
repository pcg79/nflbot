require 'spec_helper'

describe SlackNFLBot::Commands::Default, vcr: { cassette_name: 'about_commands' } do
  def app
    SlackNFLBot::App.new
  end

  it "returns the ABOUT message" do
    slack_message = <<~ABOUT
      NFLBot
      Version: #{SlackNFLBot::VERSION}
      https://github.com/pcg79/nflbot
    ABOUT

    expect(message: "nflbot", channel: 'channel').to respond_with_slack_message(slack_message)
  end

end
