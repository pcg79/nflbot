module SlackNFLBot
  module Commands
    class Score < SlackRubyBot::Commands::Base

      command "scores" do |client, data, match|
        week = ::Week.current_week

        client.say(text: "Latest scores:\n#{week.all_scores.chomp}", channel: data.channel, thread_ts: data.thread_ts || data.ts)
      end

      match /how((’|')d| did) my team do\??$/ do |client, data, match|
        team = ::Team.get_team(data)
        week = ::Week.current_week

        if game = week.find_game_by_team(team)
          message = game.to_s
        else
          message = "Looks like your team didn't play this week"
        end

        client.say(text: message.chomp, channel: data.channel)
      end

    end
  end
end
