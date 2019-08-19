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

    slack_message = "Latest standings:\nACE | 1 | Buffalo Bills\nACE | 2 | New England Patriots\nACE | 3 | New York Jets\nACE | 4 | Miami Dolphins\nACN | 1 | Baltimore Ravens\nACN | 2 | Pittsburgh Steelers\nACN | 3 | Cleveland Browns\nACN | 4 | Cincinnati Bengals\nACS | 1 | Tennessee Titans\nACS | 2 | Houston Texans\nACS | 3 | Indianapolis Colts\nACS | 4 | Jacksonville Jaguars\nACW | 1 | Oakland Raiders\nACW | 2 | Kansas City Chiefs\nACW | 3 | Denver Broncos\nACW | 4 | Los Angeles Chargers\nNCE | 1 | New York Giants\nNCE | 2 | Philadelphia Eagles\nNCE | 3 | Dallas Cowboys\nNCE | 4 | Washington Redskins\nNCN | 1 | Minnesota Vikings\nNCN | 2 | Green Bay Packers\nNCN | 3 | Detroit Lions\nNCN | 4 | Chicago Bears\nNCS | 1 | Carolina Panthers\nNCS | 2 | Tampa Bay Buccaneers\nNCS | 3 | New Orleans Saints\nNCS | 4 | Atlanta Falcons\nNCW | 1 | San Francisco 49ers\nNCW | 2 | Seattle Seahawks\nNCW | 3 | Arizona Cardinals\nNCW | 4 | Los Angeles Rams"
    expect(message: "nflbot standings", channel: 'channel').to respond_with_slack_message(slack_message)
  end

end
