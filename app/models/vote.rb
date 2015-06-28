class Vote < ActiveRecord::Base
  belongs_to  :user
  belongs_to  :voteable, polymorphic: true

  validates :voteable, presence: true
  validates :user, presence: true, uniqueness: { scope: [:voteable_id, :voteable_type] }
  validates :like, presence: true, inclusion: { in: [1, -1] }

end
