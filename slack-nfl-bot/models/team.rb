class Team < Base
  class << self

    def get_team(slack_user_id)
      find_team_by_slack_user_id(slack_user_id) || assign_team(slack_user_id)
    end

    def find_team_by_slack_user_id(slack_user_id)
      teams.join(:employees_teams, team_id: :id).where(slack_user_id: slack_user_id.to_s).get(:name)
    end

    def assign_team(slack_user_id)
      team = random_team
      employees_teams = database[:employees_teams]
      employees_teams.insert(slack_user_id: slack_user_id, team_id: team[:id])

      team[:name]
    end

    def random_team
      teams.order(Sequel.lit('RANDOM()')).first
    end

    def teams
      database[:teams]
    end

  end
end
