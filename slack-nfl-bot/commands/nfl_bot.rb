require "slack-ruby-bot"
require "sqlite3"

module SlackNFLBot
  module Commands
    class NFLBot < SlackRubyBot::Commands::Base

      command(/(what(’|')s|which is) my team/, /(what|which) team((’|')s| is) mine/) do |client, data, match|
        team = get_team(data.user)
        client.say(text: "<@#{data.user}>, your team is the *#{team}*", channel: data.channel)
      end

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

      private

      class << self
        def get_team(slack_user_id)
          (find_team_by_slack_user_id(slack_user_id) || assign_team(slack_user_id)).first
        end

        def find_team_by_slack_user_id(slack_user_id)
          rows = database.execute <<-SQL
            select name from teams t join employees_teams et
              on t.id = et.team_id
              where et.slack_user_id = '#{slack_user_id}'
          SQL

          rows.first
        end

        def assign_team(slack_user_id)
          team_id = rand(32)
          database.execute "insert into employees_teams(slack_user_id, team_id)
              values( ?, ? )", [slack_user_id, team_id]

          rows = database.execute <<-SQL
            select name from teams where id = #{team_id}
          SQL

          rows.first
        end

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
          SQLite3::Database.new "db/production.db"
        end
      end
    end
  end
end
