require 'rails_helper'

describe SubscribeQuestionJob do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }

  it "subscribe owner to question" do
    expect { SubscribeQuestionJob.perform_now(question) }.to change(user.subscribes,  :count).by(1)
  end

  it "create subscribe to question" do
    expect { SubscribeQuestionJob.perform_now(question) }.to change(question.subscribes,  :count).by(1)
  end
end
