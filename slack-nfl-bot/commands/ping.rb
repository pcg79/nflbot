module SlackNFLBot
  module Commands
    class Ping < SlackRubyBot::Commands::Base
      command 'ping'

      def self.call(client, data, match)
        client.say(text: "<@#{data.user}> - pong", channel: data.channel)
      end

    end
  end
end
