require 'terminal-table'

class Standings < Base
  attr_reader :teams

  DIVISIONS = {
    "ACE" => "AFC East",
    "ACN" => "AFC North",
    "ACS" => "AFC South",
    "ACW" => "AFC West",
    "NCE" => "NFC East",
    "NCN" => "NFC North",
    "NCS" => "NFC South",
    "NCW" => "NFC West",
  }

  def self.latest
    self.new
  end

  def initialize
    @teams = parse_standings_feed
  end

  def print
    table = [].tap do |rows|
      group_by_division_and_sort_by_rank.each do |division_array|
        div, teams = division_array

        if !rows.empty?
          rows << :separator
        end

        rows << [{ value: division_full_name(div), colspan: 2 }]

        teams.each do |team|
          rows << [team.division_rank, team.full_name]
        end
      end
    end.compact

    "```#{Terminal::Table.new(rows: table, style: { border_top: false, border_bottom: false }).to_s}```"
  end

  private

  def division_full_name(division_abbr)
    DIVISIONS[division_abbr]
  end

  def parse_standings_feed
    standings_data = json_data
    [].tap do |teams|
      standings_data["teamStandings"].each do |team_standing_element|
        team_attributes = team_standing_element["team"]
        standing_attributes = team_standing_element["standing"]

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

  def self.json_endpoint
    "http://www.nfl.com/feeds-rs/standings.json"
  end
end
