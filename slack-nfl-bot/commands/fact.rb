require "slack-ruby-bot"

module SlackNFLBot
  module Commands
    class Fact < SlackRubyBot::Commands::Base

      match /(what(’|')s| is) a fact about my team/ do |client, data, match|
        team = ::Team.get_team(data.user)
        facts = ::Fact.find_facts(team)
        ::Fact.say_fact(client, team, facts, data.channel)
      end

      match /(what(’|')s| is) a fact about (the )?(.*)\?/ do |client, data, match|
        if team = match[4]
          facts = ::Fact.find_facts(team)
          ::Fact.say_fact(client, team, facts, data.channel)
        end
      end

    end
  end
end
