require 'terminal-table'

class Standings < Base
  attr_reader :teams

  def self.latest
    self.new
  end

  def initialize
    @teams = parse_standings_feed
  end

  def to_s(division=nil)
    table = [].tap do |rows|
      group_by_division_and_sort_by_rank.each do |division_array|
        div, teams = division_array
        if (division && division == div) || division.nil?
          teams.each do |team|
            rows << [div, team.division_rank, team.full_name]
          end
        end
        rows << :separator
      end
    end.compact

    "```#{Terminal::Table.new(rows: table[0..-2], style: { border_top: false, border_bottom: false }).to_s}```"
  end

  private

  # <standingsFeed>
  #   <season>2019</season>
  #   <seasonType>PRE</seasonType>
  #   <teamStandings>
  #     <teamStanding>
  #       <team season="2019" teamId="0200" abbr="ATL" cityState="Atlanta" fullName="Atlanta Falcons" nick="Falcons" teamType="TEAM" conferenceAbbr="NFC" divisionAbbr="NCS"/>
  #       <standing season="2019" seasonType="PRE" week="2" overallWins="0" overallLosses="3" overallTies="0" overallPtsFor="47" overallPtsAgainst="70" overallNetPts="-23" overallWinPct="0.0" netTouchdowns="-4" conferenceWins="0" conferenceLosses="0" conferenceTies="0" conferenceWinPct="0.0" divisionWins="0" divisionLosses="0" divisionTies="0" divisionWinPct="0.0" homeWins="0" homeLosses="2" homeTies="0" homeWinPct="0.0" roadWins="0" roadLosses="1" roadTies="0" roadWinPct="0.0" last5Wins="0" last5Losses="3" last5Ties="0" last5WinPct="0.0" overallStreak="3L" conferenceRank="16" divisionRank="4" clinchDivision="false" clinchDivisionAndHomefield="false" clinchPlayoff="false" clinchWc="false"/>
  #       </teamStanding>

  def parse_standings_feed
    [].tap do |teams|
      xml_data.find("/standingsFeed/teamStandings/teamStanding").each do |team_standing_element|
        team_attributes = team_standing_element.find_first("team").attributes
        standing_attributes = team_standing_element.find_first("standing").attributes

        team_params = {
          full_name: team_attributes["fullName"],
          conference_abbr: team_attributes["conferenceAbbr"],
          division_abbr: team_attributes["divisionAbbr"],

          wins: standing_attributes["overallWins"],
          losses: standing_attributes["overallLosses"],
          ties: standing_attributes["overallTies"],

          conf_wins: standing_attributes["conferenceWins"],
          conf_losses: standing_attributes["conferenceLosses"],
          conf_ties: standing_attributes["conferenceTies"],

          division_wins: standing_attributes["divisionWins"],
          division_losses: standing_attributes["divisionLosses"],
          division_ties: standing_attributes["divisionTies"],

          conference_rank: standing_attributes["conferenceRank"],
          division_rank: standing_attributes["divisionRank"],
        }

        teams << Team.new(team_params)
      end
    end
  end

  def group_by_division_and_sort_by_rank
    @group_by_division_and_sort_by_rank ||= teams.group_by { |t| t.division_abbr }
      .sort_by { |div, _| div }
      .each { |div, teams| teams.sort_by! { |t| t.division_rank } }
  end

  def self.endpoint
    "http://www.nfl.com/feeds-rs/standings"
  end
end
