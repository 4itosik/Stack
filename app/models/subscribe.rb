class Subscribe < ActiveRecord::Base
  belongs_to  :user
  belongs_to  :question, touch: true

  validates :user, presence: true, uniqueness: { scope: [:question_id] }
  validates :question, presence: true
end
