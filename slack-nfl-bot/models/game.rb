require 'date'

class Game < Base
  attr_reader :week, :game_id, :home_team_full_name, :away_team_full_name, :home_team_score, :away_team_score,
    :game_iso_time, :overtime, :phase

  def initialize(game_params)
    @week = game_params[:week]
    @game_id = game_params[:game_id]
    @home_team_full_name = game_params[:home_team]
    @away_team_full_name = game_params[:away_team]
    @home_team_score = game_params[:home_team_score]
    @away_team_score = game_params[:away_team_score]

    @game_iso_time = get_game_time(game_params[:game_iso_time])
    @phase = game_params[:phase]
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
      FINAL - OVERTIME
      SCORE
    else
      <<~SCORE
      #{format_score(away_team_full_name, away_team_supporters)}
      #{format_score(home_team_full_name, home_team_supporters)}
      #{game_day}, #{game_time}
      SCORE
    end
  end

  def title
    "#{away_team_full_name} AT #{home_team_full_name}"
  end

  def has_team?(team)
    team = team.downcase
    home_team_full_name.downcase == team || away_team_full_name.downcase == team
  end

  def home_team_supporters
    @home_team_supporters ||= real_names_by_team(home_team_full_name)
  end

  def away_team_supporters
    @away_team_supporters ||= real_names_by_team(away_team_full_name)
  end

  def highlights_readable
    "".tap do |string|
      highlights.each do |highlight|
        string << highlight.to_s
        string << "\n"
      end
    end
  end

  def highlights
    @highlights ||= [].tap do |highlights|
      highlights_data["videos"].each do |videos_data|
        highlights << Highlight.new(videos_data)
      end
    end
  end

  private

  def real_names_by_team(team)
    ids = EmployeeTeam.user_ids_group_by_team[team] || []
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
    Time.at(game_iso_time / 1000.0)
  end

  def game_day
    game_iso_time.strftime("%A")
  end

  def game_time
    game_iso_time.strftime("%H:%M:%S %Z")
  end

  def final?
    phase == "FINAL"
  end

  def overtime?
    phase == "FINAL_OVERTIME"
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

  def highlights_data
    json_data(highlights_endpoint)
  end

  def highlights_endpoint
    "http://www.nfl.com/feeds-rs/videos/gameHighlights/byGame/#{game_id}.json"
  end

  def self.slack_client
    @slack_client ||= SlackNFLBot::SlackClient.new
  end
end
