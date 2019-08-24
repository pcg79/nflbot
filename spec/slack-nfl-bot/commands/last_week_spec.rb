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

    slack_message = "Last week's scores:\n*Philadelphia Eagles* (24)\nJacksonville Jaguars (10)\n\nFINAL\n\n*New York Jets* (22)\nAtlanta Falcons (10)\n\nFINAL\n\nGreen Bay Packers (13)\n*Baltimore Ravens* (26)\n\nFINAL\n\n*Cincinnati Bengals* (23)\nWashington Redskins (13)\n\nFINAL\n\n*Oakland Raiders* (33)\nArizona Cardinals (26)\n\nFINAL\n\n*Buffalo Bills* (27)\nCarolina Panthers (14)\n\nFINAL\n\nChicago Bears (13)\n*New York Giants* (32)\n\nFINAL\n\nMiami Dolphins (14)\n*Tampa Bay Buccaneers* (16)\n\nFINAL\n\n*Cleveland Browns* (21)\nIndianapolis Colts (18)\n\nFINAL\n\n*New England Patriots* (22)\nTennessee Titans (17)\n\nFINAL\n\nKansas City Chiefs (7)\n*Pittsburgh Steelers* (17)\n\nFINAL\n\nDetroit Lions (23)\n*Houston Texans* (30)\n\nFINAL\n\n*Dallas Cowboys* (14)\nLos Angeles Rams (10)\n\nFINAL\n\n*New Orleans Saints* (19)\nLos Angeles Chargers (17)\n\nFINAL\n\nSeattle Seahawks (19)\n*Minnesota Vikings* (25)\n\nFINAL\n\n*San Francisco 49ers* (24)\nDenver Broncos (15)\n\nFINAL\n"
    expect(message: "nflbot last week", channel: 'channel').to respond_with_slack_message(slack_message)
  end

  it "returns last week's score for your team" do
    expect(::Team).to receive(:get_team).and_return("Washington Redskins")
    expect(::Week).to receive(:week_specific_scores_endpoint).and_return(week_2_scores_url)
    expect(::Week).to receive(:current_week_endpoint).and_return(current_week_url)

    slack_message = "*Cincinnati Bengals* (23)\nWashington Redskins (13)\n\nFINAL\n"
    expect(message: "nflbot how'd my team do last week", channel: 'channel').to respond_with_slack_message(slack_message)
  end

end
