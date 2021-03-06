class Question < ActiveRecord::Base
  include Voteable
  include Commentable

  default_scope { order('created_at DESC') }

  scope :previous_day, -> { where("created_at >= ?", Time.zone.now.beginning_of_day) }

  belongs_to            :user

  has_many              :answers, dependent: :destroy
  has_many              :attachments, as: :attachable, dependent: :destroy
  has_many              :subscribes, dependent: :destroy

  validates             :title, presence: true, length: { minimum: 15, maximum: 150 }
  validates             :body, presence: true, length: { minimum: 30 }
  validates             :user, presence: true

  accepts_nested_attributes_for :attachments, :reject_if => :all_blank, :allow_destroy => true

  after_create          :subscribe

  def subscribe?(user)
    subscribes.where(user: user).exists?
  end

  private

  def subscribe
    SubscribeQuestionJob.perform_later(self)
  end
end
