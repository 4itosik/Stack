module Voted
  extend ActiveSupport::Concern

  included do
    before_action :set_voteable, only: [:like, :dislike, :cancel_vote]
    before_action :check_vote, only: [:like, :dislike]
    before_action :owner_voteable, only: [:like, :dislike, :cancel_vote]
  end

  def like
    @vote = @voteable.votes.new(user: current_user, like: 1)
    render_vote
  end

  def dislike
    @vote = @voteable.votes.new(user: current_user, like: -1)
    render_vote
  end

  def cancel_vote
    @vote = current_user.vote_for(@voteable)
    if @vote
      @vote.destroy
      render json: { vote: @vote, total_votes: @voteable.total_votes }
    else
      render json: "You not onwer!", status: :unprocessable_entity
    end
  end

  private
    def set_voteable
      @voteable = model_klass.find(params[:id])
    end

    def model_klass
      controller_name.classify.constantize
    end

    def owner_voteable
      redirect_to root_url, notice: "Access denied" if @voteable.user == current_user
    end

    def render_vote
      if @vote.save
        render json: { vote: @vote, total_votes: @voteable.total_votes }
      else
        render json: @vote.errors.full_messages.join("\n"), status: :unprocessable_entity
      end
    end

    def check_vote
      render json: "You have already voted for this #{@voteable.class.to_s.downcase}", status: :unprocessable_entity if @voteable.voted_by?(current_user)
    end
end