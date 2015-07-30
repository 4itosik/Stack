require 'rails_helper'

describe AnswersController do
  it_should_behave_like "voted"

  let(:question) { create(:question) }
  let(:answer) { create(:answer, question: question)}

  describe "GET #edit" do
    login_user
    let(:answer) { create(:answer, question: question, user: @user) }
    before { get :edit, id: answer }

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
      before(:each) { |ex| post :create, question_id: question, answer: attributes_for(:answer), format: :js unless ex.metadata[:skip] }
      it "save new answer for @question", skip_before: true do
        expect { post :create, question_id: question, answer: attributes_for(:answer), format: :js }.to change(question.answers, :count).by(1)
      end

      it "render create template" do
        expect(response).to render_template :create
      end

      it "add answer to user" do
        expect(assigns(:answer).user).to eq @user
      end
    end

    context "with invalid attributes" do
      it "not save answer" do
        expect { post :create,  question_id: question,
                                answer: attributes_for(:invalid_answer), format: :js }.to_not change(Answer, :count)
      end

      it "render error" do
        post :create,  question_id: question, answer: attributes_for(:invalid_answer), format: :js
        expect(response).to render_template :create
      end
    end
  end

  describe "PATCH #update" do
    login_user

    context "owner answer" do
      let(:answer) { create(:answer, user: @user) }

      context "with valid attributes" do
        before { patch :update, id: answer, answer: { body: "Changes new big body for answer" }, format: :js }

        it "assigns the requested answer for @answer for @question" do
          expect(assigns(:answer)).to eq answer
        end

        it "changes answer attributes" do
          answer.reload
          expect(answer.body).to eq "Changes new big body for answer"
        end

        it "render update template" do
          expect(response).to render_template :update
        end
      end

      context "with invalid attributes" do
        before { patch :update, id: answer, answer: { body: "Shot body" }, format: :js }

        it "do not change answer attributes" do
          answer.reload
          expect(answer.body).to eq "Test big body for answer for question"
        end

        it "re-render form" do
          expect(response).to render_template :update
        end
      end
    end

    context "non-owner answer" do
      let(:owner_user) { create(:user) }
      let(:answer) { create(:answer, question: question, user: owner_user) }
      before { patch :update, id: answer, answer: { body: "Changes new big body for answer" }, format: :js }

      it "does not change answer attributes" do
        answer.reload
        expect(answer.body).to eq "Test big body for answer for question"
      end

      it "render forbidden" do
        expect(response).to be_forbidden
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
        expect{ delete :destroy, id: answer, format: :js }.to change(question.answers, :count).by(-1)
      end

      it "render destroy template" do
        delete :destroy, id: answer, format: :js
        expect(response).to render_template :destroy
      end
    end

    context "non-owner delete answer" do
      let(:question) { create(:question) }
      let(:owner) { create(:user) }
      let(:answer) { create(:answer, question: question, user: owner) }
      before { answer }
      login_user

      it "does not delete question" do
        expect{ delete :destroy, id: answer, format: :js }.to_not change(Answer, :count)
      end

      it "render forbidden" do
        delete :destroy, id: answer, format: :js
        expect(response).to be_forbidden
      end

    end
  end

  describe "POST #best" do
    login_user

    context "onwer select best answer" do
      let(:question) { create(:question, user: @user) }
      let(:answer) { create(:answer, question: question) }

      before { post :best, id: answer, format: :js }

      it "best answer" do
        expect(answer.reload.best).to be_truthy
      end

      it "render best template" do
        expect(response).to render_template :best
      end
    end

    context "non-onwer select best answer" do
      let(:owner) { create(:user) }
      let(:question) { create(:question, user: owner) }
      let(:answer) { create(:answer, question: question) }

      it "render forbidden" do
        post :best, id: answer, format: :js
        expect(response).to be_forbidden
      end
    end

  end


  describe "POST #cancel_best" do
    login_user

    context "owner select best answer" do
      let(:question) { create(:question, user: @user) }
      let(:best_answer) { create(:best, question: question) }

      before { post :cancel_best, id: best_answer, format: :js }

      it "cancel best answer" do
        expect(best_answer.reload.best).to be false
      end

      it "render cancel best template" do
        expect(response).to render_template :cancel_best
      end
    end

    context "non-owner select best answer" do
      let(:owner) { create(:user) }
      let(:question) { create(:question, user: owner) }
      let(:answer) { create(:answer, question: question) }

      it "render forbidden" do
        post :cancel_best, id: answer, format: :js
        expect(response).to be_forbidden
      end
    end

  end
end
