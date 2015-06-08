class Question < ActiveRecord::Base
  validates             :title, presence: true, length: { minimum: 15, maximum: 150 }
  validates             :body, presence: true, length: { minimum: 30 }
  validates             :user, presence: true

  has_many              :answers, dependent: :destroy

  belongs_to            :user
end
