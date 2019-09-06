module SlackNFLBot
  module Commands
    class Highlights < SlackRubyBot::Commands::Base
      command "highlights" do |client, data, _match|
        team = ::Team.get_team(data)
        week = ::Week.current_week

        message = if game = week.find_game_by_team(team.full_name)
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

        client.say(text: message, channel: data.channel)
      end
    end
  end
end
