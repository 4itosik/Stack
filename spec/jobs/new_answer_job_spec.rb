require 'rails_helper'

describe NewAnswerJob do
  let(:question) { create(:question) }
  let(:users) { create_list(:user, 2) }
  let(:answer) { create(:answer, question: question) }

  before do
    users.each {|user| question.subscribes.create(user: user)}
  end

  it "should send daily digest to all users" do
    users.each { |user| expect(NewAnswerMailer).to receive(:information).with(question, user, answer).and_call_original }
    NewAnswerJob.perform_now(answer)
  end
end
