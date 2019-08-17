module SlackNFLBot
  module Commands
    class Team < SlackRubyBot::Commands::Base

      command(/(what|which)((’|')s| is) my team.*/, /(what|which) team((’|')s| is) mine.*/) do |client, data, match|
        team = ::Team.get_team(data)
        client.say(text: "<@#{data.user}>, your team is the *#{team}*", channel: data.channel)
      end

    end
  end
end
