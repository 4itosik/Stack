require 'rails_helper'

describe AttachmentsController do
  describe "DELETE #destroy" do
    describe "question" do
      context "owner delete attachment" do
        login_user
        let(:question) { create(:question, user: @user) }
        let!(:attachment) { create(:attachment, attachable: question) }

        it "delete attachment" do
          expect{ delete :destroy, question_id: question, id: attachment, format: :js }.to change(question.attachments, :count).by(-1)
        end

        it "render destroy template" do
          delete :destroy, question_id: question, id: attachment, format: :js
          expect(response).to render_template :destroy
        end
      end

      context "non-owner delete attachment" do
        let(:question) { create(:question) }
        let(:owner) { create(:user) }
        let!(:attachment) { create(:attachment, attachable: question) }
        login_user

        it "does not delete attachment" do
          expect{ delete :destroy, question_id: question, id: attachment, format: :js }.to_not change(Attachment, :count)
        end

        it "redirect to root path" do
          delete :destroy, question_id: question, id: attachment, format: :js
          expect(response).to redirect_to root_path
        end

      end
    end

    describe "answer" do
      context "owner delete attachment" do
        login_user
        let(:question) { create(:question) }
        let(:answer) { create(:answer, question: question, user: @user)}
        let!(:attachment) { create(:attachment, attachable: answer) }

        it "delete attachment" do
          expect{ delete :destroy, answer_id: answer, id: attachment, format: :js }.to change(answer.attachments, :count).by(-1)
        end

        it "render destroy template" do
          delete :destroy, answer_id: answer, id: attachment, format: :js
          expect(response).to render_template :destroy
        end
      end

      context "non-owner delete attachment" do
        let(:question) { create(:question) }
        let(:answer) { create(:answer, question: question)}
        let(:owner) { create(:user) }
        let!(:attachment) { create(:attachment, attachable: answer) }
        login_user

        it "does not delete attachment" do
          expect{ delete :destroy, answer_id: answer, id: attachment, format: :js }.to_not change(Attachment, :count)
        end

        it "redirect to root path" do
          delete :destroy, answer_id: answer, id: attachment, format: :js
          expect(response).to redirect_to root_path
        end

      end
    end

  end

end
