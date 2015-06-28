require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:votes).dependent(:destroy) }

  describe "#vote_for" do
    let(:user) { create(:user) }
    let(:question) { create(:question) }
    let!(:vote) { create(:vote, voteable: question, user: user) }
    let!(:vote_2) { create(:vote, voteable: question) }

    it "" do
      expect(user.vote_for(question)).to eq vote
    end

    it "nil" do
      expect(user.vote_for(vote_2)).to be_nil
    end
  end
end
