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

    slack_message = "Latest standings:\n| ACE | 1 | Buffalo Bills        |\n| ACE | 2 | New England Patriots |\n| ACE | 3 | New York Jets        |\n| ACE | 4 | Miami Dolphins       |\n+-----+---+----------------------+\n| ACN | 1 | Baltimore Ravens     |\n| ACN | 2 | Pittsburgh Steelers  |\n| ACN | 3 | Cleveland Browns     |\n| ACN | 4 | Cincinnati Bengals   |\n+-----+---+----------------------+\n| ACS | 1 | Tennessee Titans     |\n| ACS | 2 | Houston Texans       |\n| ACS | 3 | Indianapolis Colts   |\n| ACS | 4 | Jacksonville Jaguars |\n+-----+---+----------------------+\n| ACW | 1 | Oakland Raiders      |\n| ACW | 2 | Kansas City Chiefs   |\n| ACW | 3 | Denver Broncos       |\n| ACW | 4 | Los Angeles Chargers |\n+-----+---+----------------------+\n| NCE | 1 | New York Giants      |\n| NCE | 2 | Philadelphia Eagles  |\n| NCE | 3 | Dallas Cowboys       |\n| NCE | 4 | Washington Redskins  |\n+-----+---+----------------------+\n| NCN | 1 | Minnesota Vikings    |\n| NCN | 2 | Green Bay Packers    |\n| NCN | 3 | Detroit Lions        |\n| NCN | 4 | Chicago Bears        |\n+-----+---+----------------------+\n| NCS | 1 | Carolina Panthers    |\n| NCS | 2 | Tampa Bay Buccaneers |\n| NCS | 3 | New Orleans Saints   |\n| NCS | 4 | Atlanta Falcons      |\n+-----+---+----------------------+\n| NCW | 1 | San Francisco 49ers  |\n| NCW | 2 | Seattle Seahawks     |\n| NCW | 3 | Arizona Cardinals    |\n| NCW | 4 | Los Angeles Rams     |"
    expect(message: "nflbot standings", channel: 'channel').to respond_with_slack_message(slack_message)
  end

end
