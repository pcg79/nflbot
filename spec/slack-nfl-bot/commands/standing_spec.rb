require 'spec_helper'

describe SlackNFLBot::Commands::Standings do
  def app
    SlackNFLBot::App.new
  end

  def scores_url
    File.join(File.dirname(__FILE__), "..", "..", "fixtures", "nfl_feed_standings.xml")
  end

  it "returns the latest standings for all teams" do
    expect(Standings).to receive(:endpoint).and_return(scores_url)

    slack_message = "Latest standings:\n```| AFC East                 |\n| 1 | Buffalo Bills        |\n| 2 | New England Patriots |\n| 3 | New York Jets        |\n| 4 | Miami Dolphins       |\n+---+----------------------+\n| AFC North                |\n| 1 | Baltimore Ravens     |\n| 2 | Pittsburgh Steelers  |\n| 3 | Cleveland Browns     |\n| 4 | Cincinnati Bengals   |\n+---+----------------------+\n| AFC South                |\n| 1 | Tennessee Titans     |\n| 2 | Houston Texans       |\n| 3 | Indianapolis Colts   |\n| 4 | Jacksonville Jaguars |\n+---+----------------------+\n| AFC West                 |\n| 1 | Oakland Raiders      |\n| 2 | Kansas City Chiefs   |\n| 3 | Denver Broncos       |\n| 4 | Los Angeles Chargers |\n+---+----------------------+\n| NFC East                 |\n| 1 | New York Giants      |\n| 2 | Philadelphia Eagles  |\n| 3 | Dallas Cowboys       |\n| 4 | Washington Redskins  |\n+---+----------------------+\n| NFC North                |\n| 1 | Minnesota Vikings    |\n| 2 | Green Bay Packers    |\n| 3 | Detroit Lions        |\n| 4 | Chicago Bears        |\n+---+----------------------+\n| NFC South                |\n| 1 | Carolina Panthers    |\n| 2 | Tampa Bay Buccaneers |\n| 3 | New Orleans Saints   |\n| 4 | Atlanta Falcons      |\n+---+----------------------+\n| NFC West                 |\n| 1 | San Francisco 49ers  |\n| 2 | Seattle Seahawks     |\n| 3 | Arizona Cardinals    |\n| 4 | Los Angeles Rams     |```"
    expect(message: "nflbot standings", channel: 'channel').to respond_with_slack_message(slack_message)
  end

end
