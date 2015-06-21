class Answer < ActiveRecord::Base
  default_scope { order('best DESC') }

  validates             :body, presence: true, length: { minimum: 30, maximum: 350 }
  validates             :question, presence: true
  validates             :user, presence: true

  belongs_to            :question
  belongs_to            :user

  def select_best
    transaction do
      question.answers.update_all(best: false)
      update!(best: true)
    end
  end

  def cancel_best
    transaction { update!(best: false) }
  end

end
