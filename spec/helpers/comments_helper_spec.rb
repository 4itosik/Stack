require "rails_helper"
describe CommentsHelper do
  describe "#question_id" do
    let(:question) { create(:question) }
    let(:answer) { create(:answer, question: question) }

    it "parent question" do
      comment = create(:comment, commentable: question)
      expect(question_id(comment)).to eq question.id
    end

    it "parent answer" do
      comment = create(:comment, commentable: answer)
      expect(question_id(comment)).to eq question.id
    end
  end
end
