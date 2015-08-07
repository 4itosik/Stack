class Api::V1::QuestionsController < Api::V1::BaseController
  load_and_authorize_resource  :question

  def index
    respond_with(Question.all, each_serializer: QuestionInCollectionSerializer)
  end

  def show
    respond_with(@question)
  end

  def create
    respond_with(@question = Question.create(question_params.merge(user: current_user)))
  end

  private

  def question_params
    params.require(:question).permit(:body, :title)
  end
end