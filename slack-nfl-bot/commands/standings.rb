module SlackNFLBot
  module Commands
    class Standings < SlackRubyBot::Commands::Base

      command "standings" do |client, data, match|
        standings = ::Standings.latest
        client.say(
          text: "Latest standings:\n#{standings.print}",
          channel: data.channel,
          thread_ts: data.thread_ts || data.ts
        )
      end

    end
  end
end
