require "slack-ruby-bot"

module SlackNFLBot
  module Commands
    class Fact < SlackRubyBot::Commands::Base

      match /(what(’|')s| is) a fact about my team/ do |client, data, match|
        team = get_team(data.user)
        facts = find_facts(team)
        say_fact(client, team, facts, data.channel) if facts
      end

      match /(what(’|')s| is) a fact about (the )?(.*)\?/ do |client, data, match|
        if team = match[4]
          facts = find_facts(team)
          if facts
            say_fact(client, team, facts, data.channel)
          else
            client.say(text: "I don't have any facts about the *#{team}* :cry:", channel: data.channel)
          end
        end
      end

      class << self

        def find_facts(team_name)
          rows = database.execute <<-SQL
            select fact from teams_facts tf join teams t
              on tf.team_id = t.id
              where lower(t.name) like lower('%#{team_name}%')
          SQL

          rows.first
        end

        def say_fact(client, team, facts, channel)
          client.say(text: "Here's a fun fact about the *#{team}*: #{facts.sample}", channel: channel)
        end

        def database
          SlackNFLBot::Database.database
        end
      end

    end
  end
end
