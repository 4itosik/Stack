require 'rails_helper'

describe Answer do
  it { should validate_presence_of :body }
  it { should validate_presence_of :question }
  it { should validate_presence_of :user }

  it { should validate_length_of(:body).is_at_least 30 }
  it { should validate_length_of(:body).is_at_most 350 }

  it { should belong_to :question }
  it { should belong_to :user }

  it_should_behave_like "attachable"
  it_should_behave_like "voteable"
  it_should_behave_like "commentable"

  describe "#select best" do
    let(:question) { create(:question) }
    let(:answer) { create(:answer, question: question) }

    it "" do
      answer.select_best
      expect(answer.best).to be_truthy
    end

    it "false other answer" do
      other_answer = create(:answer, question: question, best: true)
      answer.select_best
      expect(other_answer.reload.best).to be false
    end
  end

  it "#cancel best" do
    answer = create(:answer, best: true)
    answer.cancel_best
    expect(answer.best).to be false
  end

  describe "#send_information" do
    subject { build(:answer) }

    it 'should subscribe after creating' do
      expect(NewAnswerJob).to receive(:perform_later).with(subject)
      subject.save!
    end

    it 'should not subscribe after update' do
      subject.save!
      expect(NewAnswerJob).to_not receive(:perform_later)
      subject.update(body: '123')
    end
  end
end