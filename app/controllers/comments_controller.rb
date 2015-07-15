class CommentsController < ApplicationController
  before_action :set_commentable

  respond_to  :js

  def new
    respond_with(@comment = @commentable.comments.new)
  end

  def create
    respond_with(@comment = @commentable.comments.create(comment_params.merge(user: current_user)))
  end

  private
    def set_commentable
      @commentable = commentable_name.classify.constantize.find(params[:"#{commentable_name.singularize}_id"])
    end

    def commentable_name
      params[:commentable]
    end

    def comment_params
      params.require(:comment).permit(:body)
    end
end
