class Comment < ActiveRecord::Base
  belongs_to  :user
  belongs_to  :commentable, polymorphic: true, touch: true

  validates :user, :commentable, presence: true
  validates :body, presence: true, length: { minimum: 3 }
end
