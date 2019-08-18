require 'open-uri'
require 'xml'

class Week < Base
  attr_reader :games

  def self.current_week
    self.new
  end

  def initialize
    @games = parse_games
  end

  def all_scores
    games.map(&:to_s).join("\n")
  end

  def find_game_by_team(team)
    games.detect { |g| g.has_team?(team) }
  end

  private

  def parse_games
    [].tap do |games|
      xml_data.find("/scoresFeed/gameScores/gameScore").each do |game_score_element|
        game_data_attrs = game_score_element.find_first("gameSchedule").attributes
        game_params = {
          week: game_data_attrs["week"],
          home_team: game_data_attrs["homeDisplayName"],
          away_team: game_data_attrs["visitorDisplayName"],
          game_day: game_data_attrs["gameDate"],
          game_time: game_data_attrs["isoTime"],
        }

        # /score only exists if the game has started
        if score_element = game_score_element.find_first("score")
          score_element_attrs = score_element.attributes
          home_team_attrs = score_element.find_first("homeTeamScore").attributes
          away_team_attrs = score_element.find_first("visitorTeamScore").attributes

          score_params = {
            status: score_element_attrs["phase"],
            home_team_score: home_team_attrs["pointTotal"],
            away_team_score: away_team_attrs["pointTotal"],
          }

          game_params.merge! score_params
        end

        games << Game.new(game_params)
      end
    end
  end

  def self.endpoint
    "http://www.nfl.com/feeds-rs/scores"
  end

end
