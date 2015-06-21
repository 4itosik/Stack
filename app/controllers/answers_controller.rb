class AnswersController < ApplicationController
  before_action :load_question
  before_action :load_answer, except: [:create]
  before_action :owner_answer, except: [:create, :best, :cancel_best]
  before_action :owner_question, only: [:best, :cancel_best]

  respond_to :js

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
      params.require(:answer).permit(:body)
    end

    def load_answer
      @answer = @question.answers.find(params[:id])
    end

    def owner_answer
      redirect_to root_url, notice: "Access denied" unless @answer.user == current_user
    end

    def owner_question
      redirect_to root_url, notice: "Access denied" unless @question.user == current_user
    end
end
