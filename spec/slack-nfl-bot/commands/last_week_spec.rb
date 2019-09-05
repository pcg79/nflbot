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
    allow_any_instance_of(Game).to receive(:home_team_supporters).and_return(["Pat"])
    allow_any_instance_of(Game).to receive(:away_team_supporters).and_return(["Ethan", "Kalani"])

    slack_message = "Last week's scores:\n*Philadelphia Eagles (Ethan, Kalani) (24)*\nJacksonville Jaguars (Pat) (10)\nFINAL\n\n*New York Jets (Ethan, Kalani) (22)*\nAtlanta Falcons (Pat) (10)\nFINAL\n\nGreen Bay Packers (Ethan, Kalani) (13)\n*Baltimore Ravens (Pat) (26)*\nFINAL\n\n*Cincinnati Bengals (Ethan, Kalani) (23)*\nWashington Redskins (Pat) (13)\nFINAL\n\n*Oakland Raiders (Ethan, Kalani) (33)*\nArizona Cardinals (Pat) (26)\nFINAL\n\n*Buffalo Bills (Ethan, Kalani) (27)*\nCarolina Panthers (Pat) (14)\nFINAL\n\nChicago Bears (Ethan, Kalani) (13)\n*New York Giants (Pat) (32)*\nFINAL\n\nMiami Dolphins (Ethan, Kalani) (14)\n*Tampa Bay Buccaneers (Pat) (16)*\nFINAL\n\n*Cleveland Browns (Ethan, Kalani) (21)*\nIndianapolis Colts (Pat) (18)\nFINAL\n\n*New England Patriots (Ethan, Kalani) (22)*\nTennessee Titans (Pat) (17)\nFINAL\n\nKansas City Chiefs (Ethan, Kalani) (7)\n*Pittsburgh Steelers (Pat) (17)*\nFINAL\n\nDetroit Lions (Ethan, Kalani) (23)\n*Houston Texans (Pat) (30)*\nFINAL\n\n*Dallas Cowboys (Ethan, Kalani) (14)*\nLos Angeles Rams (Pat) (10)\nFINAL\n\n*New Orleans Saints (Ethan, Kalani) (19)*\nLos Angeles Chargers (Pat) (17)\nFINAL\n\nSeattle Seahawks (Ethan, Kalani) (19)\n*Minnesota Vikings (Pat) (25)*\nFINAL\n\n*San Francisco 49ers (Ethan, Kalani) (24)*\nDenver Broncos (Pat) (15)\nFINAL"
    expect(message: "nflbot last week", channel: 'channel').to respond_with_slack_message(slack_message)
  end

  context "returns last week's score for your team" do
    it "with a contraction" do
      expect(::Team).to receive(:get_team).and_return(redskins)
      expect_any_instance_of(Week).to receive(:games_data).and_return(current_week_data, games_data)
      allow_any_instance_of(Game).to receive(:home_team_supporters).and_return(["Pat"])
      allow_any_instance_of(Game).to receive(:away_team_supporters).and_return(["Ethan", "Kalani"])

      slack_message = "*Cincinnati Bengals (Ethan, Kalani) (23)*\nWashington Redskins (Pat) (13)\nFINAL\n"
      expect(message: "nflbot how'd my team do last week", channel: 'channel').to respond_with_slack_message(slack_message)
    end

    it "with bad grammar" do
      expect(::Team).to receive(:get_team).and_return(redskins)
      expect_any_instance_of(Week).to receive(:games_data).and_return(current_week_data, games_data)
      allow_any_instance_of(Game).to receive(:home_team_supporters).and_return(["Pat"])
      allow_any_instance_of(Game).to receive(:away_team_supporters).and_return(["Ethan", "Kalani"])

      slack_message = "*Cincinnati Bengals (Ethan, Kalani) (23)*\nWashington Redskins (Pat) (13)\nFINAL\n"
      expect(message: "nflbot howd my team do last week", channel: 'channel').to respond_with_slack_message(slack_message)
    end
  end

end
