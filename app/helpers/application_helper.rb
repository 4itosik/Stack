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
end
