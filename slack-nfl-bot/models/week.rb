require 'open-uri'
require 'xml'

require 'slack-nfl-bot/models/game'

class Week < Base
  attr_reader :week_number, :games

  def initialize
    @week_number = week_number
    @games = parse_games
  end

  def all_scores
    games.map(&:to_s).join("\n")
  end

  private

  def self.scores_url
    "http://www.nfl.com/liveupdate/scorestrip/ss.xml"
  end

  def week_number
    xml_data.find_first("/ss/gms").attributes["w"]
  end

  def parse_games
    [].tap do |games|
      xml_data.find("/ss/gms/g").each do |game_element|
        games << Game.new(week_number, game_element)
      end
    end
  end

  def xml_data
    @xml_data ||= XML::Document.string(open(Week.scores_url).read)
  end

end
