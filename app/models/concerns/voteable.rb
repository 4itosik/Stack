module Voteable
  extend ActiveSupport::Concern

  included do
    has_many  :votes, as: :voteable, dependent: :destroy
  end

  def total_votes
    votes.sum(:like)
  end

  def voted_by?(user)
    votes.where(user: user).exists?
  end
end
