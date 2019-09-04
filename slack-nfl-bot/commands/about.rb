require_relative "../about"

module SlackNFLBot
  module Commands
    class Default < SlackRubyBot::Commands::Base
      match(/^(?<bot>\w*)$/)

      def self.call(client, data, _match)
        client.say(
          text: SlackNFLBot::ABOUT,
          channel: data.channel,
          thread_ts: data.thread_ts || data.ts
        )
      end
    end
  end
end
