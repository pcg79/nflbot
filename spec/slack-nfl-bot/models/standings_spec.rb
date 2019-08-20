require 'spec_helper'

describe Standings do
  let(:teams) do
    [
      Team.new(
        full_name: "NFC East Team 1",
        conference_abbr: "NFC",
        division_abbr: "NFE",

        wins: 1,
        losses: 0,
        ties: 0,

        conf_wins: 1,
        conf_losses: 0,
        conf_ties: 0,

        division_wins: 1,
        division_losses: 0,
        division_ties: 0,

        conference_rank: 1,
        division_rank: 1,
      ),
      Team.new(
        full_name: "NFC East Team 2",
        conference_abbr: "NFC",
        division_abbr: "NFE",

        wins: 0,
        losses: 1,
        ties: 0,

        conf_wins: 0,
        conf_losses: 1,
        conf_ties: 0,

        division_wins: 0,
        division_losses: 1,
        division_ties: 0,

        conference_rank: 2,
        division_rank: 2,
      ),
    ]
  end

  subject(:standings) do
    expect_any_instance_of(Standings).to receive(:parse_standings_feed).and_return(teams)

    described_class.new
  end

  context "#to_s" do

    it "returns the teams in the right order" do
      expected_output = "| NFE | 1 | NFC East Team 1 |\n| NFE | 2 | NFC East Team 2 |"
      expect(standings.to_s).to eq expected_output
    end
  end

end
