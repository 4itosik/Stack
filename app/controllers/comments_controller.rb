class CommentsController < ApplicationController
  before_action :set_commentable

  def new
    @comment = @commentable.comments.new
  end

  def create
    @comment = @commentable.comments.new(comment_params)
    @comment.user = current_user
    render :new unless @comment.save
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
