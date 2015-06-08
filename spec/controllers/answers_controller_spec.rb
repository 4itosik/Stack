require 'rails_helper'

describe AnswersController do
  let(:question) { create(:question) }
  let(:answer) { create(:answer, question: question)}

  describe "GET #edit" do
    login_user
    let(:answer) { create(:answer, question: question, user: @user) }
    before { get :edit, question_id: question, id: answer }

    it "assigns the requested answer to @answer for @question" do
      expect(assigns(:answer)).to eq answer
    end

    it "render edit view" do
      expect(response).to render_template :edit
    end
  end

  describe "POST #create" do
    login_user

    context "with valid attributes" do
      before(:each) { |ex| post :create, question_id: question, answer: attributes_for(:answer) unless ex.metadata[:skip] }
      it "save new answer for @question", skip_before: true do
        expect { post :create, question_id: question, answer: attributes_for(:answer) }.to change(question.answers, :count).by(1)
      end

      it "redirect to answer" do
        expect(response).to redirect_to question_path(question)
      end

      it "add answer to user" do
        expect(assigns(:answer).user).to eq @user
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
    login_user

    context "owner answer" do
      let(:answer) { create(:answer, question: question, user: @user) }

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

    context "non-owner answer" do
      let(:owner_user) { create(:user) }
      let(:answer) { create(:answer, question: question, user: owner_user) }
      before { patch :update, question_id: question, id: answer, answer: { body: "Changes new big body for answer" } }

      it "does not change answer attributes" do
        answer.reload
        expect(answer.body).to eq "Test big body for answer for question"
      end

      it "redirect to root path" do
        expect(response).to redirect_to root_path
      end
    end
  end

  describe "DELETE #destroy" do
    context "owner delete answer" do
      login_user
      let(:question) { create(:question) }
      let(:answer) { create(:answer, question: question, user: @user)}

      before { answer }

      it "delete answer" do
        expect{ delete :destroy, question_id: question, id: answer }.to change(question.answers, :count).by(-1)
      end

      it "redirect to answers path" do
        delete :destroy, question_id: question, id: answer
        expect(response).to redirect_to question_path(question)
      end
    end

    context "non-owner delete answer" do
      let(:question) { create(:question) }
      let(:owner) { create(:user) }
      let(:answer) { create(:answer, question: question, user: owner) }
      before { answer }
      login_user

      it "does not delete question" do
        expect{ delete :destroy, question_id: question , id: answer }.to_not change(Answer, :count)
      end

      it "redirect to root path" do
        delete :destroy, question_id: question, id: answer
        expect(response).to redirect_to root_path
      end

    end

  end

end
