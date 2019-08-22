module SlackNFLBot
  module Commands
    class LastWeek < SlackRubyBot::Commands::Base
      command "last week" do |client, data, match|
       last_week = ::Week.last_week

        client.say(text: "Last week's scores:\n#{last_week.all_scores}", channel: data.channel)
      end

      match /how('d| did) my team do last week\??/ do |client, data, match|
        team = ::Team.get_team(data)
        week = ::Week.last_week

        if game = week.find_game_by_team(team)
          message = game.to_s
        else
          message = "Looks like your team didn't play last week"
        end

        client.say(text: message, channel: data.channel)
      end

    end
  end
end
