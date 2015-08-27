class Answer < ActiveRecord::Base
  include Voteable
  include Commentable

  default_scope { order('best DESC') }

  belongs_to            :question, touch: true
  belongs_to            :user

  has_many              :attachments, as: :attachable, dependent: :destroy

  validates             :body, presence: true, length: { minimum: 30, maximum: 350 }
  validates             :question, presence: true
  validates             :user, presence: true

  accepts_nested_attributes_for :attachments, :reject_if => :all_blank, :allow_destroy => true

  after_create  :send_information

  def select_best
    transaction do
      question.answers.update_all(best: false)
      update!(best: true)
    end
  end

  def cancel_best
    transaction { update!(best: false) }
  end

  private

  def send_information
    NewAnswerJob.perform_later(self)
  end
end
