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
    expect(::Week).to receive(:week_specific_scores_endpoint).and_return(week_2_scores_url)
    expect(::Week).to receive(:current_week_endpoint).and_return(current_week_url)

    slack_message = "Last week's scores:\nJacksonville Jaguars (10)\n\n*Philadelphia Eagles* (24)\n\nFINAL\n\nAtlanta Falcons (10)\n\n*New York Jets* (22)\n\nFINAL\n\nBaltimore Ravens (26)\n\n*Green Bay Packers* (13)\n\nFINAL\n\nWashington Redskins (13)\n\n*Cincinnati Bengals* (23)\n\nFINAL\n\nArizona Cardinals (26)\n\n*Oakland Raiders* (33)\n\nFINAL\n\nCarolina Panthers (14)\n\n*Buffalo Bills* (27)\n\nFINAL\n\nNew York Giants (32)\n\n*Chicago Bears* (13)\n\nFINAL\n\nTampa Bay Buccaneers (16)\n\n*Miami Dolphins* (14)\n\nFINAL\n\nIndianapolis Colts (18)\n\n*Cleveland Browns* (21)\n\nFINAL\n\nTennessee Titans (17)\n\n*New England Patriots* (22)\n\nFINAL\n\nPittsburgh Steelers (17)\n\n*Kansas City Chiefs* (7)\n\nFINAL\n\nHouston Texans (30)\n\n*Detroit Lions* (23)\n\nFINAL\n\nLos Angeles Rams (10)\n\n*Dallas Cowboys* (14)\n\nFINAL\n\nLos Angeles Chargers (17)\n\n*New Orleans Saints* (19)\n\nFINAL\n\nMinnesota Vikings (25)\n\n*Seattle Seahawks* (19)\n\nFINAL\n\nDenver Broncos (15)\n\n*San Francisco 49ers* (24)\n\nFINAL\n"
    expect(message: "nflbot last week", channel: 'channel').to respond_with_slack_message(slack_message)
  end

  it "returns last week's score for your team" do
    expect(::Team).to receive(:get_team).and_return("Washington Redskins")
    expect(::Week).to receive(:week_specific_scores_endpoint).and_return(week_2_scores_url)
    expect(::Week).to receive(:current_week_endpoint).and_return(current_week_url)

    slack_message = "*Washington Redskins* (13) LOST TO *Cincinnati Bengals* (23)"
    expect(message: "nflbot how'd my team do last week", channel: 'channel').to respond_with_slack_message(slack_message)
  end

end
