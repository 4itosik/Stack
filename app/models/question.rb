class Question < ActiveRecord::Base
  belongs_to            :user

  has_many              :answers, dependent: :destroy
  has_many              :attachments, as: :attachable, dependent: :destroy

  validates             :title, presence: true, length: { minimum: 15, maximum: 150 }
  validates             :body, presence: true, length: { minimum: 30 }
  validates             :user, presence: true

  accepts_nested_attributes_for :attachments, :reject_if => :all_blank, :allow_destroy => true
end
