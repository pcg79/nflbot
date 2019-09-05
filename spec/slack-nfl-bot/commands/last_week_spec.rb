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

  let(:games_data) { JSON.load(File.open(week_2_scores_url)) }
  let(:current_week_data) { JSON.load(File.open(current_week_url)) }
  let(:redskins) {
    Team.new({
      full_name: "Washington Redskins",
    })
  }

  it "returns last week's scores" do
    expect_any_instance_of(Week).to receive(:games_data).and_return(current_week_data, games_data)
    expect_any_instance_of(SlackNFLBot::SlackClient).to receive(:real_name).and_return("Pat", "Ethan", "Kalani")

    slack_message = "Last week's scores:\n*Philadelphia Eagles (24)*\nJacksonville Jaguars (10)\nFINAL\n\n*New York Jets (22)*\nAtlanta Falcons (Pat) (10)\nFINAL\n\nGreen Bay Packers (13)\n*Baltimore Ravens (26)*\nFINAL\n\n*Cincinnati Bengals (23)*\nWashington Redskins (Ethan, Kalani) (13)\nFINAL\n\n*Oakland Raiders (33)*\nArizona Cardinals (26)\nFINAL\n\n*Buffalo Bills (27)*\nCarolina Panthers (14)\nFINAL\n\nChicago Bears (13)\n*New York Giants (32)*\nFINAL\n\nMiami Dolphins (14)\n*Tampa Bay Buccaneers (16)*\nFINAL\n\n*Cleveland Browns (21)*\nIndianapolis Colts (18)\nFINAL\n\n*New England Patriots (22)*\nTennessee Titans (17)\nFINAL\n\nKansas City Chiefs (7)\n*Pittsburgh Steelers (17)*\nFINAL\n\nDetroit Lions (23)\n*Houston Texans (30)*\nFINAL\n\n*Dallas Cowboys (14)*\nLos Angeles Rams (10)\nFINAL\n\n*New Orleans Saints (19)*\nLos Angeles Chargers (17)\nFINAL\n\nSeattle Seahawks (19)\n*Minnesota Vikings (25)*\nFINAL\n\n*San Francisco 49ers (24)*\nDenver Broncos (15)\nFINAL"
    expect(message: "nflbot last week", channel: 'channel').to respond_with_slack_message(slack_message)
  end

  context "returns last week's score for your team" do
    it "with a contraction" do
      expect(::Team).to receive(:get_team).and_return(redskins)
      expect_any_instance_of(Week).to receive(:games_data).and_return(current_week_data, games_data)
      expect_any_instance_of(SlackNFLBot::SlackClient).to receive(:real_name).and_return("Pat", "Ethan")

      slack_message = "*Cincinnati Bengals (23)*\nWashington Redskins (Pat, Ethan) (13)\nFINAL\n"
      expect(message: "nflbot how'd my team do last week", channel: 'channel').to respond_with_slack_message(slack_message)
    end

    it "with bad grammar" do
      expect(::Team).to receive(:get_team).and_return(redskins)
      expect_any_instance_of(Week).to receive(:games_data).and_return(current_week_data, games_data)
      expect_any_instance_of(SlackNFLBot::SlackClient).to receive(:real_name).and_return("Pat", "Ethan")

      slack_message = "*Cincinnati Bengals (23)*\nWashington Redskins (Pat, Ethan) (13)\nFINAL\n"
      expect(message: "nflbot howd my team do last week", channel: 'channel').to respond_with_slack_message(slack_message)
    end
  end

end
