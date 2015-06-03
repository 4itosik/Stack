class Answer < ActiveRecord::Base
  validates             :body, presence: true, length: { minimum: 30, maximum: 350 }
  validates             :question, presence: true 
  
  belongs_to            :question
end
