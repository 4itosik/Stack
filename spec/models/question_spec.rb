require 'rails_helper'

describe Question do
  it { should validate_presence_of :title }
  it { should validate_presence_of :body }
  it { should validate_presence_of :user }

  it { should validate_length_of(:title).is_at_least 15 }
  it { should validate_length_of(:title).is_at_most 150 }
  it { should validate_length_of(:body).is_at_least 30 }

  it { should belong_to :user }

  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:subscribes).dependent(:destroy) }

  it_should_behave_like "attachable"
  it_should_behave_like "voteable"
  it_should_behave_like "commentable"

  describe "#subscribe?" do
    let(:user) { create(:user) }
    let(:question) { create(:question) }

    context "true" do
      let!(:subscribe) { create(:subscribe, user: user, question: question) }

      it { expect(question.subscribe?(user)).to be_truthy }
    end

    context "false" do
      it { expect(question.subscribe?(user)).to be_falsey }
    end
  end

  describe "#subscribe" do
    let(:user) { create(:user) }
    subject { build(:question, user: user) }

    it 'should subscribe after creating' do
      expect(SubscribeQuestionJob).to receive(:perform_later).with(subject)
      subject.save!
    end

    it 'should not subscribe after update' do
      subject.save!
      expect(SubscribeQuestionJob).to_not receive(:perform_later)
      subject.update(body: '123')
    end
  end
end
