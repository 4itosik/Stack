require "rails_helper"

shared_examples "voteable" do
  it { should have_many(:votes).dependent(:destroy) }

  describe "#total_votes" do
    let(:voteable) { create(described_class.to_s.underscore.to_sym) }
    let(:vote) { create(:vote, voteable: voteable) }

    it "empty then 0" do
      expect(voteable.total_votes).to eq 0
    end

    it "one vote" do
      vote
      expect(voteable.total_votes).to eq 1
    end

    it "many vote" do
      vote
      create_list(:vote, 3,voteable: voteable, like: -1)
      expect(voteable.total_votes).to eq -2
    end
  end

  describe "#voted_by?" do
    let(:user) { create(:user) }
    let(:voteable) { create(described_class.to_s.underscore.to_sym) }
    let(:vote) { create(:vote, voteable: voteable, user: user) }

    it "false if user not vote for voteable" do
      expect(voteable.voted_by?(user)).to be_falsey
    end

    it "true if user vote for voteable" do
      vote
      expect(voteable.voted_by?(user)).to be_truthy
    end
  end
end
