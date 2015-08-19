class SubscribeQuestionJob < ActiveJob::Base
  queue_as :default

  def perform(question)
    question.subscribes.create(user: question.user)
  end
end
