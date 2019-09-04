module SlackNFLBot
  module Commands
    class Standings < SlackRubyBot::Commands::Base

      command "standings" do |client, data, match|
        standings = ::Standings.latest
        message = if standings.week_number
          "Week #{standings.week_number} standings\n#{standings.print}"
        else
          "For some reason, there's no data for this week"
        end

        client.say(
          text: message,
          channel: data.channel,
          thread_ts: data.thread_ts || data.ts
        )
      end

    end
  end
end
