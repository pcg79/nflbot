module SlackNFLBot
  module Commands
    class Team < SlackRubyBot::Commands::Base

      command(/(what|which)((’|')s| is) my team.*/, /(what|which) team((’|')s| is) mine.*/) do |client, data, match|
        team = ::Team.get_team(slack_user_id(data))
        client.say(text: "<@#{data.user}>, your team is the *#{team}*", channel: data.channel)
      end

      # Only did this so I could override the method in the tests.  I hate that.
      def self.slack_user_id(data)
        data.user
      end

    end
  end
end
