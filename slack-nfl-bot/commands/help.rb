module SlackNFLBot
  module Commands
    class Help < SlackRubyBot::Commands::Base
      command 'help' do |client, data, _match|
        help_message = <<~HELP
        Bot for all things* NFL

        *what's my team* (and variations) - Tells you your team if you have one, assigns you one if you don't.
        *how'd my team do* (and variations) - Tells you how your team did in the latest game.
        *scores* - Recap of the week including scores and upcoming games for the week.
        *standings* - Current NFL standings by division

        * All things I've coded at least
        HELP

        client.say(text: help_message, channel: data.channel)
      end
    end
  end
end
