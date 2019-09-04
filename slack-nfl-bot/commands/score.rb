module SlackNFLBot
  module Commands
    class Score < SlackRubyBot::Commands::Base

      command "scores" do |client, data, match|
        week = ::Week.current_week

        client.say(text: "Week #{week.week_number} scores:\n#{week.all_scores.chomp}", channel: data.channel, thread_ts: data.thread_ts || data.ts)
      end

      match /how((’|')?d| did) my team do\??$/ do |client, data, match|
        team = ::Team.get_team(data)
        week = ::Week.current_week

        if game = week.find_game_by_team(team.full_name)
          message = "Week #{week.week_number}\n#{game.to_s}"
        else
          message = "Looks like your team didn't play in week #{week.week_number}"
        end

        client.say(text: message.chomp, channel: data.channel)
      end

    end
  end
end
