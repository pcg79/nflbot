require "slack-ruby-bot"
require "sqlite3"


class NFLBot < SlackRubyBot::Bot
  command 'ping' do |client, data, match|
    client.say(text: 'pong', channel: data.channel)
  end

  match /(what|which)(\'s| is) my team/ do |client, data, match|
    announce_team(client, data['user'], data.channel)
  end

  match /(what|which) team(\'s| is) mine/ do |client, data, match|
    announce_team(client, data['user'], data.channel)
  end

  private

  class << self
    def announce_team(client, slack_user_id, channel)
      team = find_team_by_slack_user_i(slack_user_id) || assign_team(slack_user_id)

      client.say(text: "Your team is the #{team.first}", channel: channel)
    end

    def find_team_by_slack_user_id(slack_user_id)
      puts "slack_user_id = #{slack_user_id}"
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

    def database
      SQLite3::Database.new "production.db"
    end
  end
end

NFLBot.run
