require 'rails_helper'

describe Answer do
  it { should validate_presence_of :body }
  it { should validate_presence_of :question }
  it { should validate_presence_of :user }

  it { should validate_length_of(:body).is_at_least 30 }
  it { should validate_length_of(:body).is_at_most 350 }

  it { should belong_to :question }
  it { should belong_to :user }

  it { should have_many(:attachments).dependent(:destroy) }

  it { should accept_nested_attributes_for :attachments }

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

end