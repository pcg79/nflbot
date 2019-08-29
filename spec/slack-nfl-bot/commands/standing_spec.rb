require 'spec_helper'

describe SlackNFLBot::Commands::Standings do
  def app
    SlackNFLBot::App.new
  end

  def scores_url
    File.join(File.dirname(__FILE__), "..", "..", "fixtures", "nfl_feed_standings.json")
  end

  it "returns the latest standings for all teams" do
    expect(Standings).to receive(:json_endpoint).and_return(scores_url)

    slack_message = "Week 2 standings\n```| AFC East                 | W | L | T |\n| 1 | Buffalo Bills        | 2 | 0 | 0 |\n| 2 | New England Patriots | 1 | 0 | 0 |\n| 3 | New York Jets        | 1 | 1 | 0 |\n| 4 | Miami Dolphins       | 1 | 1 | 0 |\n+---+----------------------+---+---+---+\n| AFC North                | W | L | T |\n| 1 | Baltimore Ravens     | 2 | 0 | 0 |\n| 2 | Pittsburgh Steelers  | 1 | 0 | 0 |\n| 3 | Cleveland Browns     | 1 | 0 | 0 |\n| 4 | Cincinnati Bengals   | 1 | 1 | 0 |\n+---+----------------------+---+---+---+\n| AFC South                | W | L | T |\n| 1 | Tennessee Titans     | 1 | 0 | 0 |\n| 2 | Houston Texans       | 0 | 1 | 0 |\n| 3 | Indianapolis Colts   | 0 | 1 | 0 |\n| 4 | Jacksonville Jaguars | 0 | 2 | 0 |\n+---+----------------------+---+---+---+\n| AFC West                 | W | L | T |\n| 1 | Oakland Raiders      | 2 | 0 | 0 |\n| 2 | Kansas City Chiefs   | 1 | 0 | 0 |\n| 3 | Denver Broncos       | 1 | 1 | 0 |\n| 4 | Los Angeles Chargers | 0 | 1 | 0 |\n+---+----------------------+---+---+---+\n| NFC East                 | W | L | T |\n| 1 | New York Giants      | 2 | 0 | 0 |\n| 2 | Philadelphia Eagles  | 1 | 1 | 0 |\n| 3 | Dallas Cowboys       | 0 | 1 | 0 |\n| 4 | Washington Redskins  | 0 | 2 | 0 |\n+---+----------------------+---+---+---+\n| NFC North                | W | L | T |\n| 1 | Minnesota Vikings    | 1 | 0 | 0 |\n| 2 | Green Bay Packers    | 1 | 1 | 0 |\n| 3 | Detroit Lions        | 0 | 1 | 0 |\n| 4 | Chicago Bears        | 0 | 2 | 0 |\n+---+----------------------+---+---+---+\n| NFC South                | W | L | T |\n| 1 | Carolina Panthers    | 1 | 1 | 0 |\n| 2 | Tampa Bay Buccaneers | 1 | 1 | 0 |\n| 3 | New Orleans Saints   | 0 | 1 | 0 |\n| 4 | Atlanta Falcons      | 0 | 3 | 0 |\n+---+----------------------+---+---+---+\n| NFC West                 | W | L | T |\n| 1 | San Francisco 49ers  | 1 | 0 | 0 |\n| 2 | Seattle Seahawks     | 1 | 0 | 0 |\n| 3 | Arizona Cardinals    | 1 | 1 | 0 |\n| 4 | Los Angeles Rams     | 0 | 1 | 0 |```"
    expect(message: "nflbot standings", channel: 'channel').to respond_with_slack_message(slack_message)
  end

end
