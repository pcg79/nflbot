require "slack-ruby-bot"

module SlackNFLBot
  module Commands
    class Team < SlackRubyBot::Commands::Base

      command(/(what(’|')s|which is) my team/, /(what|which) team((’|')s| is) mine/) do |client, data, match|
        team = get_team(data.user)
        client.say(text: "<@#{data.user}>, your team is the *#{team}*", channel: data.channel)
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

        def database
          SlackNFLBot::Database.database
        end
      end
    end
  end
end
