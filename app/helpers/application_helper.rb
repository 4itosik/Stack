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

  def object_cache_key_for(object, user = nil)
    user_id = user ? user.id : 0
    "#{object.class.to_s.pluralize.downcase}/#{object.id}-#{object.updated_at.try(:utc).try(:to_s, :number)}-#{user_id}"
  end

  def collection_cache_key_for(model, user = nil)
    user_id = user ? user.id : 0
    klass = model.to_s.capitalize.constantize
    count = klass.count
    max_updated_at = klass.maximum(:updated_at).try(:utc).try(:to_s, :number)
    "#{model.to_s.pluralize}/collection-#{count}-#{max_updated_at}-#{user_id}"
  end

  def cache_key_form(form_name, user = nil)
    user_id = user ? 1 : 0
    "#{form_name}-#{user_id}"
  end
end
