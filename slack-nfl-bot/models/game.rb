require 'date'

class Game
  attr_reader :week, :home_team, :away_team, :home_team_score, :away_team_score,
    :game_iso_time, :overtime, :status

  def initialize(game_params)
    @week = game_params[:week]
    @home_team = game_params[:home_team]
    @away_team = game_params[:away_team]
    @home_team_score = game_params[:home_team_score]
    @away_team_score = game_params[:away_team_score]
    @game_iso_time = Time.iso8601(game_params[:game_iso_time])
    @status = game_params[:status]
  end

  def to_s
    str = ""
    if final? || (overtime? && tie?)
      "*#{home_team}* (#{home_team_score}) #{result} *#{away_team}* (#{away_team_score})"
    elsif overtime?
      "*#{home_team}* (#{home_team_score}) #{result} *#{away_team}* (#{away_team_score}) in overtime"
    else
      "*#{home_team}* will play *#{away_team}* on #{game_day} at #{game_time}"
    end
  end

  def has_team?(team)
    home_team == team || away_team == team
  end

  private

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
end
