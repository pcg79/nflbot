class EmployeeTeam < Base

  class << self

    def user_ids_group_by_team
      grouped_hashes = employees_teams.join(:teams, id: :team_id).select(:slack_user_id, :name).all.group_by { |h| h[:name] }

      grouped_hashes.each { |k, array| grouped_hashes[k] = array.map { |hash| hash[:slack_user_id] } }
    end

    def employee_slack_ids_by_team(team_name)
      employees_teams.join(:teams, id: :team_id).select(:slack_user_id, :name).where(name: team_name)
    end

    def employees_teams
      @employees_teams ||= database[:employees_teams]
    end

  end
end
