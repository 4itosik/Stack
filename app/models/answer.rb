class Answer < ActiveRecord::Base
  validates             :body, presence: true, length: { minimum: 30, maximum: 350 }
  validates             :question, presence: true
  validates             :user, presence: true

  belongs_to            :question
  belongs_to            :user
end
