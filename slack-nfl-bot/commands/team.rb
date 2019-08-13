require "slack-ruby-bot"

module SlackNFLBot
  module Commands
    class Team < SlackRubyBot::Commands::Base

      command(/(what(’|')s|which is) my team/, /(what|which) team((’|')s| is) mine/) do |client, data, match|
        team = ::Team.get_team(data.user)
        client.say(text: "<@#{data.user}>, your team is the *#{team}*", channel: data.channel)
      end

    end
  end
end
