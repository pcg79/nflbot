module SlackNFLBot
  module Commands
    class Highlights < SlackRubyBot::Commands::Base

      match /^highlights$/ do |client, data, _match|
        team = ::Team.get_team(data)

        message = highlights_message(team.full_name)
        client.say(text: message, channel: data.channel)
      end

      match /highlights for (the )?([\w\s]+)/ do |client, data, _match|
        if team = match[2]
          message = highlights_message(team)
          client.say(text: message, channel: data.channel)
        end
      end

      def self.highlights_message(team_name)
        week = ::Week.current_week

        if game = week.find_game_by_team(team_name)
          if !game.highlights.empty?
            <<~TEXT
            Here are the highlights for the *#{game.title}* game:
            #{game.highlights_readable}
            TEXT
          else
            "Highlights for *#{game.title}* are not yet available"
          end
        else
          "Looks like your team didn't play in week #{week.week_number}"
        end
      end

    end
  end
end
