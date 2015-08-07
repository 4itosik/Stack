class Api::V1::AnswersController < Api::V1::BaseController
  load_and_authorize_resource  :question
  load_and_authorize_resource  :answer, through:  :question

  def index
    respond_with(@question.answers, each_serializer: AnswerInCollectionSerializer)
  end

  def show
    respond_with(@answer)
  end

  def create
    respond_with(@answer = @question.answers.create(answer_params.merge(user: current_user)))
  end

  private
  def answer_params
    params.require(:answer).permit(:body)
  end
end