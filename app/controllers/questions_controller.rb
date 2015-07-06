class QuestionsController < ApplicationController
  before_action :load_question, only: [:show, :edit, :update, :destroy]
  before_action :owner_question, only: [:edit, :update, :destroy]

  include Voted

  def index
    @questions = Question.all
  end


  def show
    @answer = Answer.new(:question => @question)
    @answer.attachments.build
  end

  def new
    @question = Question.new
    @question.attachments.build
  end

  def edit
  end

  def create
    @question = Question.new(question_params)
    @question.user = current_user
    if @question.save
      flash[:notice] = "Your question successfully created"
    else
      render :new
    end
  end

  def update
    if @question.update(question_params)
      flash[:notice] = "Your question successfully update"
      redirect_to @question
    else
      render :edit
    end
  end

  def destroy
    @question.destroy
    flash[:notice] = "Your question successfully destroy"
    redirect_to questions_path
  end

  private
    def load_question
      @question = Question.find(params[:id])
    end

    def question_params
      params.require(:question).permit(:body, :title, attachments_attributes: [:id, :file, :_destroy])
    end

    def owner_question
      redirect_to root_url, notice: "Access denied" unless @question.user == current_user
    end

end
