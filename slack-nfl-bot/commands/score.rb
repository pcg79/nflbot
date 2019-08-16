module SlackNFLBot
  module Commands
    class Score < SlackRubyBot::Commands::Base

      command "scores" do |client, data, match|
        week = ::Week.new

        client.say(text: "Latest scores:\n#{week.all_scores}", channel: data.channel)
      end

      match /how('d| did) my team do\??/ do |client, data, match|
        team = ::Team.get_team(slack_user_id(data))
        week = ::Week.new

        if game = week.find_game_by_team(team)
          message = game.to_s
        else
          message = "Looks like your team didn't play this week"
        end

        client.say(text: message, channel: data.channel)
      end

      # Only did this so I could override the method in the tests.  I hate that.
      def self.slack_user_id(data)
        data.user
      end

    end
  end
end
