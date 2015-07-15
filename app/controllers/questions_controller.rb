class QuestionsController < ApplicationController
  before_action :load_question, only: [:show, :edit, :update, :destroy]
  before_action :owner_question, only: [:edit, :update, :destroy]

  include Voted

  respond_to  :js, only: [:create]

  def index
    respond_with(@questions = Question.all)
  end

  def show
  end

  def new
    respond_with(@question = Question.new)
  end

  def edit
  end

  def create
    respond_with(@question = Question.create(question_params.merge(user: current_user)))
  end

  def update
    @question.update(question_params)
    respond_with @question
  end

  def destroy
    respond_with(@question.destroy)
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
