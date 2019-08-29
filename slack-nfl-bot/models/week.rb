require 'open-uri'
require 'xml'

class Week < Base
  attr_reader :games, :season, :season_type, :week_number

  def self.current_week
    self.new
  end

  def self.last_week
    self.new(:previous)
  end

  def initialize(week = :current)
    url = if week == :previous
      get_previous_week_url
    end

    data = games_data(url)
    @games = parse_games(data["gameScores"])
    @season = data["season"]
    @season_type = data["seasonType"]
    @week_number = data["week"]
  end

  def all_scores
    games.map(&:to_s).join("\n")
  end

  def find_game_by_team(team)
    games.detect { |g| g.has_team?(team) }
  end

  private

  def parse_games(game_scores)
    [].tap do |games|
      game_scores.each do |game_score|
        game_data_attrs = game_score["gameSchedule"]
        game_params = {
          week: game_data_attrs["week"],
          home_team: game_data_attrs["homeDisplayName"],
          away_team: game_data_attrs["visitorDisplayName"],
          game_iso_time: game_data_attrs["isoTime"],
        }

        # /score only exists if the game has started
        if score_element = game_score["score"]
          home_team_attrs = score_element["homeTeamScore"]
          away_team_attrs = score_element["visitorTeamScore"]

          score_params = {
            status: score_element["phase"],
            home_team_score: home_team_attrs["pointTotal"],
            away_team_score: away_team_attrs["pointTotal"],
          }

          game_params.merge! score_params
        end

        games << Game.new(game_params)
      end
    end
  end

  def get_previous_week_url
    current_week_json = games_data(self.class.current_week_endpoint)
    current_week = current_week_json["week"]
    current_season_type = current_week_json["seasonType"]

    # If current week is 1 in regular season, we need to get week 4 of preseason
    # If current week is 1 in preseason, we can get week 0 (Hall of Fame game)
    # TODO: Test this logic
    if current_week == 1 && current_season_type == "REG"
      previous_week = 4
      previous_week_season_type = "PRE"
    else
      previous_week = current_week - 1
      previous_week_season_type = current_season_type
    end

    # TODO:  This is going to break in January!
    current_season = Date.today.year
    self.class.week_specific_scores_endpoint(current_season, previous_week_season_type, previous_week)
  end

  def games_data(url=nil)
    @games_data ||= json_data(url)
  end

  def self.json_endpoint
    "http://www.nfl.com/feeds-rs/scores.json"
  end

  def self.current_week_endpoint
    "http://www.nfl.com/feeds-rs/currentWeek.json"
  end

  def self.week_specific_scores_endpoint(season, season_type, week)
    "http://www.nfl.com/feeds-rs/scores/#{season}/#{season_type}/#{week}.json"
  end

end
