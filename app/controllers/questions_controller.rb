class QuestionsController < ApplicationController
  before_action :find_question, only: [:subscribe]

  load_and_authorize_resource

  include Voted

  respond_to  :js, only: [:create, :subscribe]

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

  def subscribe
    respond_with(@question.subscribes.create(user: current_user))
  end

  private
    def question_params
      params.require(:question).permit(:body, :title, attachments_attributes: [:id, :file, :_destroy])
    end

    def find_question
      @question = Question.find(params[:id])
    end
end
