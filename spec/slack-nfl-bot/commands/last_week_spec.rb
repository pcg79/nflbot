require 'spec_helper'

describe SlackNFLBot::Commands::LastWeek do
  def app
    SlackNFLBot::App.new
  end

  def week_2_scores_url
    File.join(File.dirname(__FILE__), "..", "..", "fixtures", "nfl_scores_week_2.json")
  end

  def current_week_url
    File.join(File.dirname(__FILE__), "..", "..", "fixtures", "nfl_current_week.json")
  end

  it "returns last week's scores" do
    slack_message = "Last week's scores:\n*Jacksonville Jaguars* (10) LOST TO *Philadelphia Eagles* (24)\n*Atlanta Falcons* (10) LOST TO *New York Jets* (22)\n*Baltimore Ravens* (26) BEAT *Green Bay Packers* (13)\n*Washington Redskins* (13) LOST TO *Cincinnati Bengals* (23)\n*Arizona Cardinals* (26) LOST TO *Oakland Raiders* (33)\n*Carolina Panthers* (14) LOST TO *Buffalo Bills* (27)\n*New York Giants* (32) BEAT *Chicago Bears* (13)\n*Tampa Bay Buccaneers* (16) BEAT *Miami Dolphins* (14)\n*Indianapolis Colts* (18) LOST TO *Cleveland Browns* (21)\n*Tennessee Titans* (17) LOST TO *New England Patriots* (22)\n*Pittsburgh Steelers* (17) BEAT *Kansas City Chiefs* (7)\n*Houston Texans* (30) BEAT *Detroit Lions* (23)\n*Los Angeles Rams* (10) LOST TO *Dallas Cowboys* (14)\n*Los Angeles Chargers* (17) LOST TO *New Orleans Saints* (19)\n*Minnesota Vikings* (25) BEAT *Seattle Seahawks* (19)\n*Denver Broncos* (15) LOST TO *San Francisco 49ers* (24)"

    expect(::Week).to receive(:week_specific_scores_endpoint).and_return(week_2_scores_url)
    expect(::Week).to receive(:current_week_endpoint).and_return(current_week_url)

    expect(message: "nflbot last week", channel: 'channel').to respond_with_slack_message(slack_message)
  end

  it "returns last week's score for your team" do
    slack_message = "*Washington Redskins* (13) LOST TO *Cincinnati Bengals* (23)"

    expect(::Team).to receive(:get_team).and_return("Washington Redskins")
    expect(::Week).to receive(:week_specific_scores_endpoint).and_return(week_2_scores_url)
    expect(::Week).to receive(:current_week_endpoint).and_return(current_week_url)

    expect(message: "nflbot how'd my team do last week", channel: 'channel').to respond_with_slack_message(slack_message)
  end

end
