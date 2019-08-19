module SlackNFLBot
  module Commands
    class Standings < SlackRubyBot::Commands::Base

      command "standings" do |client, data, match|
        standings = ::Standings.latest
        client.say(text: "Latest standings:\n#{standings.to_s}", channel: data.channel)
      end

    end
  end
end
