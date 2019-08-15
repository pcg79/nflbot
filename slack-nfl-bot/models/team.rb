class Team < Base
  class << self

    def get_team(slack_user_id)
      (find_team_by_slack_user_id(slack_user_id) || assign_team(slack_user_id)).first
    end

    def find_team_by_slack_user_id(slack_user_id)
      teams = database[:teams]
      rows = teams.join(:employees_teams, team_id: :id).where(slack_user_id: slack_user_id)

      rows.first
    end

    def assign_team(slack_user_id)
      team_id = rand(32)
      employees_teams = database[:employees_teams]
      employees_teams.insert(slack_user_id: slack_user_id, team_id: team_id)

      rows = database[:teams].where(id: team_id)

      rows.first
    end

  end
end
