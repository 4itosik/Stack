require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:votes).dependent(:destroy) }
  it { should have_many(:authorizations).dependent(:destroy) }
  it { should have_many(:subscribes).dependent(:destroy) }

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

  describe ".find_for_oauth" do

    let!(:user) { create(:user) }
    let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456') }

    context 'user already has authorization' do
      it "returns the user" do
        user.authorizations.create(provider: 'facebook', uid: '123456', confirmation: true)
        expect(User.find_for_oauth(auth)).to eq user
      end
    end

    context "oauth with email" do
      context 'user has not authorization' do
        context 'user already exists' do
          let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456', info: { email: user.email }) }

          it "does not create new user" do
            expect{ User.find_for_oauth(auth) }.to_not change(User, :count)
          end

          it "creates authorization for user" do
            expect{ User.find_for_oauth(auth) }.to change(user.authorizations, :count).by(1)
          end

          it "create authorization with provider and uid" do
            authorization = User.find_for_oauth(auth).authorizations.first

            expect(authorization.provider).to eq auth.provider
            expect(authorization.uid).to eq auth.uid
          end

          it "returns the user" do
            expect(User.find_for_oauth(auth)).to eq user
          end
        end

        context "user does not exist" do
          let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456', info: { email: 'new@user.com' }) }

          it "create new user" do
            expect{ User.find_for_oauth(auth) }.to change(User, :count).by(1)
          end

          it "returns a new user" do
            expect( User.find_for_oauth(auth) ).to be_a(User)
          end

          it "fills new user" do
            user = User.find_for_oauth(auth)
            expect(user.email).to eq auth.info[:email]
          end

          it "create authorization for new user" do
            user = User.find_for_oauth(auth)
            expect(user.authorizations).to_not be_empty
          end

          it "create authorization with provider and uid" do
            authorization = User.find_for_oauth(auth).authorizations.first

            expect(authorization.provider).to eq auth.provider
            expect(authorization.uid).to eq auth.uid
          end
        end
      end
    end

    context "oauth without email" do
      let(:auth) { OmniAuth::AuthHash.new(provider: 'twitter', uid: '123456', info: { }) }

      it "does not create user" do
        expect{ User.find_for_oauth(auth) }.to_not change(User, :count)
      end

      it "does not create authorization" do
        expect{ User.find_for_oauth(auth) }.to_not change(Authorization, :count)
      end

      it "returns nil" do
        expect(User.find_for_oauth(auth)).to be_nil
      end
    end
  end

  describe "#owner?" do
    context "return true" do
      let(:user) { create(:user) }
      let(:question) { create(:question, user: user) }

      it { expect(user.owner?(question)).to be_truthy }
    end

    context "return false" do
      let(:user) { create(:user) }
      let(:question) { create(:question) }

      it { expect(user.owner?(question)).to be_falsey }
    end
  end

  describe ".send_daily_digest" do
    let(:users) { create_list(:user, 2) }

    it "should send daily digest to all users" do
      users.each { |user| expect(DailyMailer).to receive(:digest).with(user).and_call_original }
      User.send_daily_digest
    end
  end
end
