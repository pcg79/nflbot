module SlackNFLBot
  module Commands
    class Fact < SlackRubyBot::Commands::Base

      match /(what(’|')s| is) a fact about my team/ do |client, data, match|
        team = ::Team.get_team(data)
        fact = ::Fact.find_fact(team)
        ::Fact.say_fact(client, team, fact, data.channel)
      end

      match /(what(’|')s| is) a fact about (the )?([\w\s]+)/ do |client, data, match|
        if team = match[4]
          fact = ::Fact.find_fact(team)
          ::Fact.say_fact(client, team, fact, data.channel)
        end
      end

    end
  end
end
