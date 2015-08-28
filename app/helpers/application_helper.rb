module ApplicationHelper
  def answer_update?
    controller_name == "answers" && action_name == "update"
  end

  def shallow_path(*args)
    if args.last.persisted?
      args.last
    else
      args
    end
  end

  def collection_cache_key_for(model)
    klass = model.to_s.capitalize.constantize
    count = klass.count
    max_updated_at = klass.maximum(:updated_at).try(:utc).try(:to_s, :number)
    "#{model.to_s.pluralize}/collection-#{count}-#{max_updated_at}"
  end

  def cache_key_form(form_name, question, user = nil)
    user_id = user ? 1 : 0
    "#{form_name}-#{question.id}-#{user_id}"
  end

  def comment_cache_key(commentable)
    comments_count = commentable.comments.count
    comments_max_updated_at = commentable.comments.maximum(:updated_at).try(:utc).try(:to_s, :number)
    "#{commentable.class.to_s.pluralize.downcase}/#{commentable.id}/comments/collection-#{comments_count}-#{comments_max_updated_at}"
  end
end
