module CommentsHelper
  def question_id(comment)
    if comment.commentable_type == "Answer"
      comment.commentable.question.id
    else
      comment.commentable.id
    end
  end
end
