class AnswersController < ApplicationController
  before_action :load_question, only: [:create]
  before_action :load_answer, only: [:edit, :update, :best, :cancel_best, :destroy]
  before_action :set_question, only: [:best, :cancel_best, :update]
  before_action :owner_answer, only: [:edit, :update, :destroy]
  before_action :owner_question, only: [:best, :cancel_best]

  include Voted

  def edit
  end

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user
    render :new unless @answer.save
  end

  def update
    render :edit unless @answer.update(answer_params)
  end

  def destroy
    @answer.destroy
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

    def owner_answer
      redirect_to root_url, notice: "Access denied" unless @answer.user == current_user
    end

    def owner_question
      redirect_to root_url, notice: "Access denied" unless @question.user == current_user
    end
end
