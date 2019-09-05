class EmployeeTeam < Base

  class << self

    def user_ids_group_by_team
      @user_ids_group_by_team ||= begin
        grouped_hashes = employees_teams.join(:teams, id: :team_id).select(:slack_user_id, :name).all.group_by { |h| h[:name] }

        grouped_hashes.each { |k, array| grouped_hashes[k] = array.map { |hash| hash[:slack_user_id] } }
      end
    end

    def employees_teams
      @employees_teams ||= database[:employees_teams]
    end

  end
end
