require 'spec_helper'

describe Team do
  subject(:team) { described_class.new({
      full_name: "Washington Redskins",
    })
  }

  context "#emoji" do
    it "returns the correct emoji" do
      expect(subject.emoji).to eq "nfl-redskins"
    end
  end

end
