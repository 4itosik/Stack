require 'rails_helper'

describe QuestionsController do
  let(:question) { create(:question) }

  describe "GET #index" do
    let(:questions) { create_list(:question, 2) }

    before { get :index }

    it "populates an array of all questions" do
      expect(assigns(:questions)).to match_array(questions)
    end

    it "render index view" do
      expect(response).to render_template :index
    end
  end

  describe "GET #show" do
    before { get :show, id: question }

    it "assigns the requested question to @question" do
      expect(assigns(:question)).to eq question
    end

    it "render show view" do
      expect(response).to render_template :show
    end

    it "populates an array of all answers in this question" do
      answers = create_list(:answer, 2, question: question)
      expect(assigns(:answers)).to match_array(answers)
    end

    it "assigns a new Answer to @answer for @question" do
      expect(assigns(:answer)).to be_a_new(Answer)
    end
  end

  describe "GET #new" do
    login_user
    before { get :new }

    it "assigns a new Question to @question" do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it "render new view" do
      expect(response).to render_template :new
    end
  end

  describe "GET #edit" do
    login_user
    let(:question) { create(:question, user: @user) }
    before { get :edit, id: question }

    it "assigns the requested question to @question" do
      expect(assigns(:question)).to eq question
    end

    it "render edit view" do
      expect(response).to render_template :edit
    end
  end

  describe "POST #create" do
    login_user

    context "with valid attributes" do
      before(:each) { |ex| post :create, question: attributes_for(:question) unless ex.metadata[:skip] }

      it "save new question", skip_before: true do
        expect { post :create, question: attributes_for(:question) }.to change(Question, :count).by(1)
      end

      it "redirect to show view" do
        expect(response).to redirect_to question_path(assigns(:question))
      end

      it "add question to user" do
        expect(assigns(:question).user).to eq @user
      end
    end

    context "with invalid attributes" do
      it "not save question" do
        expect { post :create, question: attributes_for(:invalid_question) }.to_not change(Question, :count)
      end

      it "re-render new view" do
        post :create, question: attributes_for(:invalid_question)
        expect(response).to render_template :new
      end
    end
  end

  describe "PATCH #update" do
    login_user
    context "with owner question" do
      let(:question) { create(:question, user: @user) }
      context "with valid attributes" do
        before(:each) { |ex| patch :update, id: question, question: attributes_for(:question) unless ex.metadata[:skip] }

        it "assigns the requested question to @question" do
          expect(assigns(:question)).to eq question
        end

        it "changes question attributes", skip_before: true do
          patch :update, id: question, question: { title: "New big title length",
                                                   body: "New big body new big body new big" }
          question.reload
          expect(question.title).to eq "New big title length"
          expect(question.body).to eq "New big body new big body new big"
        end

        it "redirect to the update question" do
          expect(response).to redirect_to question_path(question)
        end
      end

      context "with invalid attributes" do
        before { patch :update, id: question, question: { title: "Small title", body: "Small body"} }

        it "does not change question attributes" do
          question.reload
          expect(question.title).to eq "Test string 15 length"
          expect(question.body).to eq "Test body Test body Test body "
        end

        it "re-render edit view" do
          expect(response).to render_template :edit
        end
      end
    end

    context "non-owner question" do
      let(:owner_user) { create(:user) }
      let(:question) { create(:question, user: owner_user) }

      it "does not change question attributes" do
        patch :update, id: question, question: { title: "New big title length",
                                                 body: "New big body new big body new big" }
        question.reload
        expect(question.title).to eq "Test string 15 length"
        expect(question.body).to eq "Test body Test body Test body "
      end

      it "redirect to root path" do
        patch :update, id: question, question: { title: "New big title length",
                                                 body: "New big body new big body new big" }
        expect(response).to redirect_to root_path
      end
    end
  end

  describe "DELETE #destroy" do
    context "owner delete question" do
      login_user
      let(:question) { create(:question, user: @user) }
      before { question }

      it "delete question" do
        expect{ delete :destroy, id: question }.to change(Question, :count).by(-1)
      end

      it "redirect to questions path" do
        delete :destroy, id: question
        expect(response).to redirect_to questions_path
      end
    end

    context "non-owner delete question" do
      let(:owner_user) { create(:user) }
      let(:question) { create(:question, user: owner_user) }
      before { question }
      login_user

      it "does not delete question" do
        expect{ delete :destroy, id: question }.to_not change(Question, :count)
      end

      it "redirect to root path" do
        delete :destroy, id: question
        expect(response).to redirect_to root_path
      end
    end

  end
end
