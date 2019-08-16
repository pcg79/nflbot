module SlackNFLBot
  module Commands
    class Score < SlackRubyBot::Commands::Base

      command "scores" do |client, data, match|
        week = ::Week.new

        message = "Latest scores:\n#{week.all_scores}"

        client.say(text: message, channel: data.channel)
      end

    end
  end
end
