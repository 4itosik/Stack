class Answer < ActiveRecord::Base
  include Voteable

  default_scope { order('best DESC') }

  belongs_to            :question
  belongs_to            :user

  has_many              :attachments, as: :attachable, dependent: :destroy

  validates             :body, presence: true, length: { minimum: 30, maximum: 350 }
  validates             :question, presence: true
  validates             :user, presence: true

  accepts_nested_attributes_for :attachments, :reject_if => :all_blank, :allow_destroy => true

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
