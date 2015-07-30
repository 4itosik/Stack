class AnswersController < ApplicationController
  before_action :load_question, only: [:create]
  before_action :load_answer, only: [:edit, :update, :best, :cancel_best, :destroy]
  before_action :set_question, only: [:best, :cancel_best, :update]

  include Voted

  respond_to  :js

  authorize_resource

  def edit
  end

  def create
    respond_with(@answer = @question.answers.create(answer_params.merge(user: current_user)))
  end

  def update
    respond_with(@answer.update(answer_params))
  end

  def destroy
    respond_with(@answer.destroy)
  end

  def best
    @answer.select_best
    @answers = @question.answers
  end

  def cancel_best
    @answer.cancel_best
    @answers = @question.answers
  end

  private
    def load_question
      @question = Question.find(params[:question_id])
    end

    def answer_params
      params.require(:answer).permit(:body, attachments_attributes: [:id, :file, :_destroy])
    end

    def load_answer
      @answer = Answer.find(params[:id])
    end

    def set_question
      @question = @answer.question
    end

end
