require 'rails_helper'

describe AnswersController do
  let(:question) { create(:question) }
  let(:answer) { create(:answer, question: question)}

  describe "GET #edit" do
    before { get :edit, question_id: question, id: answer }

    it "assigns the requested answer to @answer for @question" do
      expect(assigns(:answer)).to eq answer
    end

    it "render edit view" do
      expect(response).to render_template :edit
    end
  end

  describe "POST #create" do
    context "with valid attributes" do
      it "save new answer for @question" do
        expect { post :create, question_id: question, answer: attributes_for(:answer) }.to change(question.answers, :count).by(1)
      end

      it "redirect to answer" do
        post :create, question_id: question, answer: attributes_for(:answer)
        expect(response).to redirect_to question_path(question)
      end
    end

    context "with invalid attributes" do
      it "not save answer" do
        expect { post :create,  question_id: question,
                                answer: attributes_for(:invalid_answer) }.to_not change(Answer, :count)
      end

      it "render new view" do
        post :create,  question_id: question, answer: attributes_for(:invalid_answer)
        expect(response).to render_template :new
      end
    end
  end

  describe "PATCH #update" do
    context "with valid attributes" do
      before { patch :update, question_id: question, id: answer, answer: { body: "Changes new big body for answer" } }

      it "assigns the requested answer for @answer for @question" do
        expect(assigns(:answer)).to eq answer
      end

      it "changes answer attributes" do
        answer.reload
        expect(answer.body).to eq "Changes new big body for answer"
      end

      it "redirect to question" do
        expect(response).to redirect_to question_path(question)
      end
    end

    context "with invalid attributes" do
      before { patch :update, question_id: question, id: answer, answer: { body: "Shot body" } }

      it "do not change answer attributes" do
        answer.reload
        expect(answer.body).to eq "Test big body for answer for question"
      end

      it "re-render edit view" do
        expect(response).to render_template :edit
      end
    end
  end
end
