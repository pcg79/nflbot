require 'date'

class Game
  attr_reader :week, :home_team_full_name, :away_team_full_name, :home_team_score, :away_team_score,
    :game_iso_time, :overtime, :status

  def initialize(game_params)
    @week = game_params[:week]
    @home_team_full_name = game_params[:home_team]
    @away_team_full_name = game_params[:away_team]
    @home_team_score = game_params[:home_team_score]
    @away_team_score = game_params[:away_team_score]

    @game_iso_time = get_game_time(game_params[:game_iso_time])
    @status = game_params[:status]
  end

  def to_s
    if final? || (overtime? && tie?)
      <<~SCORE
      #{format_winner(home_team_full_name, away_team_full_name, home_team_score, away_team_score)}
      FINAL
      SCORE
    elsif overtime?
      <<~SCORE
      #{format_winner(home_team_full_name, away_team_full_name, home_team_score, away_team_score)}
      FINAL
      SCORE
    else
      <<~SCORE
      #{format_score(away_team_full_name, away_team_supporters)}
      #{format_score(home_team_full_name, home_team_supporters)}
      #{game_day}, #{game_time}
      SCORE
    end
  end

  def has_team?(team)
    home_team_full_name == team || away_team_full_name == team
  end

  def home_team_supporters
    @home_team_supporters ||= real_names_by_team(home_team_full_name)
  end

  def away_team_supporters
    @away_team_supporters ||= real_names_by_team(away_team_full_name)
  end

  private

  def real_names_by_team(team)
    ids = EmployeeTeam.user_ids_group_by_team[team]
    ids.map do |id|
      self.class.slack_client.real_name(id)
    end
  end

  def format_winner(home_team_full_name, away_team_full_name, home_team_score, away_team_score)
    home_team_string = format_score(home_team_full_name, home_team_supporters, home_team_score)
    away_team_string = format_score(away_team_full_name, away_team_supporters, away_team_score)

    if home_team_score >= away_team_score
      home_team_string = "*#{home_team_string}*"
    elsif away_team_score >= home_team_score
      away_team_string = "*#{away_team_string}*"
    end

    <<~SCORE.chomp
    #{away_team_string}
    #{home_team_string}
    SCORE
  end

  def format_score(team, supporters, score=nil)
    "".tap do |string|
      string << team
      string << " (#{supporters.join(", ")})" if !supporters.empty?
      string << " (#{score})" if score
    end
  end

  def get_game_time(game_iso_time)
    # Amazingly the NFL api returns iso time as a string ("2019-08-22T16:00:00-07:00") from the xml feed
    # and an int in millis (1566514800000) from the json feed.  So we have to deal with that until I
    # convert to using all json

    if game_iso_time.is_a?(String)
      Time.iso8601(game_iso_time)
    else
      Time.at(game_iso_time / 1000.0)
    end
  end

  def game_day
    game_iso_time.strftime("%A")
  end

  def game_time
    game_iso_time.strftime("%H:%M:%S %Z")
  end

  def final?
    status == "FINAL"
  end

  def overtime?
    status == "FO"
  end

  def tie?
    home_team_score == away_team_score
  end

  def result
    if home_team_score > away_team_score
      "BEAT"
    elsif home_team_score < away_team_score
      "LOST TO"
    else
      "TIED"
    end
  end

  def self.slack_client
    @slack_client ||= SlackNFLBot::SlackClient.new
  end
end
