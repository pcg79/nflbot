require 'spec_helper'

describe SlackNFLBot::Commands::Help do
  def app
    SlackNFLBot::App.new
  end

  it "helps" do
    help_message = <<~HELP.chomp
    Bot for all things* NFL

    *what's my team* (and variations) - Tells you your team if you have one, assigns you one if you don't.
    *how'd my team do* (and variations) - Tells you how your team did in the latest game.
    *what's a fact about my team* (and variations) - Tells you a fun fact about your assigned team.
    *what's a fact about [full team name]* (and variations) - Tells you a fun fact about [full team name].
    *scores* - Recap of the week including scores and upcoming games for the week.
    *standings* - Current NFL standings by division
    *assignments* - See who is legally required to support which team

    * All things I've coded at least
    HELP


    expect(message: "nflbot help", channel: "channel").to respond_with_slack_message(help_message)
  end

end
