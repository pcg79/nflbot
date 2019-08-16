class Game
  attr_reader :week, :home_team, :away_team, :home_team_score, :away_team_score,
    :game_day, :game_time, :overtime, :status

  # Example data from http://www.nfl.com/liveupdate/scorestrip/ss.xml
  # <g eid="2019081554" gsis="57858" d="Thu" t="7:00" q="F" h="JAX" hnn="jaguars" hs="10" v="PHI" vnn="eagles" vs="24" rz="0" ga="" gt="PRE"/>
  def initialize(week, data)
    attributes = data.attributes
    @week = week
    @home_team = "#{data["h"]} #{data["hnn"].capitalize}"
    @away_team = "#{data["v"]} #{data["vnn"].capitalize}"
    @home_team_score = data["hs"]
    @away_team_score = data["vs"]
    @game_day = data["d"]
    @game_time = data["t"]
    @status = data["q"]
  end

  def to_s
    str = ""
    if final? || (overtime? && tie?)
      "#{home_team} (#{home_team_score}) #{result} #{away_team} (#{away_team_score})"
    elsif overtime?
      "#{home_team} (#{home_team_score}) #{result} #{away_team} (#{away_team_score}) in overtime"
    else
      "#{home_team} will play #{away_team} on #{game_day} at #{game_time}"
    end
  end

  private

  def final?
    status == "F"
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
