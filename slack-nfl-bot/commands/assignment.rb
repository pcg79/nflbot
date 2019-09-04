module SlackNFLBot
  module Commands
    class Assignment < SlackRubyBot::Commands::Base
      command "assignments" do |client, data, _match|
        slack_users_grouped_by_team = ::EmployeeTeam.user_ids_group_by_team

        message = slack_users_grouped_by_team.keys.sort.map do |team_name|
          users = slack_users_grouped_by_team[team_name].map { |id| user_name_from_id(id) }
          "*#{team_name}*: #{users.join(", ")}"
        end.join("\n")

        client.say(
          text: message,
          channel: data.channel,
          thread_ts: data.thread_ts || data.ts
        )
      end

      def self.user_name_from_id(user_id)
        slack_client.real_name(user_id)
      end

      def self.slack_client
        @slack_client ||= SlackNFLBot::SlackClient.new
      end
    end
  end
end
