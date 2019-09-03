module SlackNFLBot
  module Commands
    class Assignment < SlackRubyBot::Commands::Base
      command "assignments" do |client, data, _match|
        slack_users_grouped_by_team = ::EmployeeTeam.employees_teams_group_by_team

        message = slack_users_grouped_by_team.keys.sort.map do |team_name|
          users = slack_users_grouped_by_team[team_name].map { |id| "<#{id}>"}
          "#{team_name}: #{users.join(",")}"
        end.join("\n")

        client.say(text: message, channel: data.channel)
      end
    end
  end
end
