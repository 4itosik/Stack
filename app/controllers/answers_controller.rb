class AnswersController < ApplicationController
  before_action :load_question
  before_action :load_answer, except: [:create]
  before_action :owner_answer, except: [:create]

  def edit
  end

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user
    if @answer.save
      flash[:notice] = "You answer successfully created"
      redirect_to @question
    else
      render :new
    end
  end

  def update
    if @answer.update(answer_params)
      flash[:notice] = "Your answer successfully update"
      redirect_to question_path(@question)
    else
      render :edit
    end
  end

  def destroy
    @answer.destroy
    flash[:notice] = "Your answer successfully destroy"
    redirect_to @question
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
end
