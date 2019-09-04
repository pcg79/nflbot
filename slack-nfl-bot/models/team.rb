class Team < Base

  attr_reader :full_name, :nickname, :division_abbr, :conference_abbr,
    :wins, :losses, :ties,
    :conf_wins, :conf_losses, :conf_ties,
    :division_wins, :division_losses, :division_ties,
    :division_rank, :conference_rank

  def initialize(params)
    @full_name = params[:full_name]
    @nickname = @full_name.split(" ")[-1].downcase
    @division_abbr = params[:division_abbr]
    @conference_abbr = params[:conference_abbr]

    @wins = params[:wins].to_i
    @losses = params[:losses].to_i
    @ties = params[:ties].to_i

    @conf_wins = params[:conf_wins].to_i
    @conf_losses = params[:conf_losses].to_i
    @conf_ties = params[:conf_ties].to_i

    @division_wins = params[:division_wins].to_i
    @division_losses = params[:division_losses].to_i
    @division_ties = params[:division_ties].to_i

    @division_rank = params[:division_rank].to_i
    @conference_rank = params[:conference_rank].to_i
  end

  def emoji
    "nfl-#{nickname}"
  end

  class << self

    def get_team(user)
      slack_user_id = slack_user_id(user)
      new(full_name: find_team_by_slack_user_id(slack_user_id) || assign_team(slack_user_id))
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
