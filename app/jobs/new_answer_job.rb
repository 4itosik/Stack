class NewAnswerJob < ActiveJob::Base
  queue_as :default

  def perform(answer)
    answer.question.subscribes.find_each do |subscribe|
      NewAnswerMailer.information(answer.question, subscribe.user, answer).deliver_later
    end
  end
end
