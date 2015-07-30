module Voted
  extend ActiveSupport::Concern

  included do
    skip_authorize_resource only: [:like, :dislike, :cancel_vote]

    before_action :set_voteable, only: [:like, :dislike, :cancel_vote]
    before_action :authorize_voteable, only: [:like, :dislike]

    respond_to :json, only: [:like, :dislike, :cancel_vote]
  end

  def like
    respond_with(@vote = @voteable.votes.create(user: current_user, like: 1)) do |format|
      format.json { render_response }
    end
  end

  def dislike
    respond_with(@vote = @voteable.votes.create(user: current_user, like: -1)) do |format|
      format.json { render_response }
    end
  end

  def cancel_vote
    authorize! :cancel_vote, @voteable
    @vote = current_user.vote_for(@voteable)
    respond_with(@vote.destroy) do |format|
      format.json { render_response }
    end
  end

  private
    def set_voteable
      @voteable = model_klass.find(params[:id])
    end

    def model_klass
      controller_name.classify.constantize
    end

    def render_response
      render 'shared/vote'
    end

    def authorize_voteable
      authorize! :vote, @voteable
    end
end