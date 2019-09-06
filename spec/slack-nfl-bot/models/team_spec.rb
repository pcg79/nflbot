require 'spec_helper'

describe Team do
  subject(:team) { described_class.new({
      full_name: "Washington Redskins",
    })
  }
  let(:user) {
    Struct.new(:user).new(1)
  }
  let(:employees_teams_table) {
    SlackNFLBot::Database.database[:employees_teams]
  }

  context "#emoji" do
    it "returns the correct emoji" do
      expect(subject.emoji).to eq "nfl-redskins"
    end
  end

  context "#get_team" do
    it "returns an already assigned team" do
      allow(Team).to receive(:find_team_by_slack_user_id).and_return("Washington Redskins")

      expect(Team.get_team(user).full_name).to eq("Washington Redskins")
      expect { Team.get_team(user) }.to change { employees_teams_table.count }.by(0)
    end

    it "assigns a team if none already assigned" do
      allow(Team).to receive(:find_team_by_slack_user_id).and_return(nil)

      expect(Team.get_team(user).full_name).not_to be_nil
    end

    it "persists the assigned team" do
      allow(Team).to receive(:find_team_by_slack_user_id).and_return(nil)

      expect { Team.get_team(user) }.to change { employees_teams_table.count }.by(1)
    end
  end

end
