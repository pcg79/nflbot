require "slack-ruby-bot"
require "sqlite3"


class NFLBot < SlackRubyBot::Bot
  command 'ping' do |client, data, match|
    client.say(text: 'pong', channel: data.channel)
  end

  match /(what|which)(\'s| is) my team/ do |client, data, match|
    team = get_team(data['user'])
    client.say(text: "Your team is the *#{team}*", channel: data.channel)
  end

  match /(what|which) team(\'s| is) mine/ do |client, data, match|
    team = get_team(data['user'])
    client.say(text: "Your team is the *#{team}*", channel: data.channel)
  end

  match /fact about my team/ do |client, data, match|
    say_fact(client, data['user'], data.channel)
  end

  match /fact about (the )?(.*)/ do |client, data, match|
    say_fact_for_team(client, match[2], data.channel) if match[2]
    # say_fact(client, match, data.channel)
  end

  private

  class << self
    def get_team(slack_user_id)
      find_team_by_slack_user_id(slack_user_id) || assign_team(slack_user_id)
    end

    def say_fact(client, slack_user_id, channel)
      if team = find_team_by_slack_user_id(slack_user_id)
        team = team.first
        if facts = find_facts(team)
          client.say(text: "Here's a fun fact about the *#{team}*: #{facts.sample}", channel: channel)
        end
      else
        client.say(text: "It doesn't look like you have a team!", channel: channel)
      end
    end

    def say_fact_for_team(client, team_name, channel)
      if facts = find_facts(team_name)
        client.say(text: "Here's a fun fact about the *#{team_name}*: #{facts.sample}", channel: channel)
      end
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

    def database
      SQLite3::Database.new "db/production.db"
    end
  end
end

NFLBot.run
