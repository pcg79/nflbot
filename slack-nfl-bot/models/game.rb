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

    @game_iso_time = get_game_time(game_params[:game_iso_time])
    @status = game_params[:status]
  end

  def to_s
    if final? || (overtime? && tie?)
      <<~SCORE
      #{format_winner(home_team, away_team, home_team_score, away_team_score)}
      FINAL
      SCORE
    elsif overtime?
      <<~SCORE
      #{format_winner(home_team, away_team, home_team_score, away_team_score)}
      FINAL
      SCORE
    else
      <<~SCORE
      #{away_team}
      #{home_team}
      #{game_day}, #{game_time}
      SCORE
    end
  end

  def has_team?(team)
    home_team == team || away_team == team
  end

  private

  def format_winner(home_team, away_team, home_team_score, away_team_score)
    if home_team_score >= away_team_score
      home_team = "*#{home_team}*"
    elsif away_team_score >= home_team_score
      away_team = "*#{away_team}*"
    end

    <<~SCORE.chomp
    #{away_team} (#{away_team_score})
    #{home_team} (#{home_team_score})
    SCORE
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
end
