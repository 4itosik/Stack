require 'rails_helper'

describe "Answers API" do
  let(:question) { create(:question) }

  describe "/index" do
    context "unauthorized" do
      it "return 401 status if there is no access_token" do
        get "/api/v1/questions/#{question.id}/answers", format: :json
        expect(response).to have_http_status 401
      end

      it "return 401 status if invalid access_token" do
        get "/api/v1/questions/#{question.id}/answers", format: :json, access_token: "12345"
        expect(response).to have_http_status 401
      end
    end

    context "authorized" do
      let(:access_token) { create(:access_token) }
      let!(:answer) { create(:answer, question: question) }
      let!(:old_answer) { create(:answer, question: question, created_at: 2.days.ago) }

      before { get "/api/v1/questions/#{question.id}/answers", format: :json, access_token: access_token.token }

      it "return 200 status" do
        expect(response).to be_success
      end

      it "contains list of questions" do
        expect(response.body).to have_json_size(2).at_path("answers")
      end

      %w(id body created_at updated_at).each do |attr|
        it "questions contains #{attr}" do
          expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("answers/0/#{attr}")
        end
      end
    end
  end

  describe "/show" do
    let(:answer) { create(:answer, question: question) }

    context "unauthorized" do
      it "return 401 status if there is no access_token" do
        get "/api/v1/questions/#{question.id}/answers/#{answer.id}", format: :json
        expect(response).to have_http_status 401
      end

      it "return 401 status if invalid access_token" do
        get "/api/v1/questions/#{question.id}/answers/#{answer.id}", format: :json, access_token: "12345"
        expect(response).to have_http_status 401
      end
    end

    context "authorized" do
      let!(:comment) { create(:comment, commentable: answer) }
      let!(:attachment) { create(:attachment, attachable: answer) }

      let(:access_token) { create(:access_token) }

      before { get "/api/v1/questions/#{question.id}/answers/#{answer.id}", format: :json, access_token: access_token.token }

      it "return 200 status" do
        expect(response).to be_success
      end

      %w(id body created_at updated_at).each do |attr|
        it "questions contains #{attr}" do
          expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("answer/#{attr}")
        end
      end

      context "comments" do
        it 'included in question object' do
          expect(response.body).to have_json_size(1).at_path("answer/comments")
        end

        %w(id body).each do |attr|
          it "contains #{attr}" do
            expect(response.body).to be_json_eql(comment.send(attr.to_sym).to_json).at_path("answer/comments/0/#{attr}")
          end
        end
      end

      context "attachments" do
        it 'included in question object' do
          expect(response.body).to have_json_size(1).at_path("answer/attachments")
        end


        it "contains url" do
          expect(response.body).to be_json_eql(attachment.file.url.to_json).at_path("answer/attachments/0/url")
        end
      end
    end
  end

  describe "/create" do
    context "unauthorized" do
      it "return 401 status if there is no access_token" do
        post "/api/v1/questions/#{question.id}/answers", answer: attributes_for(:answer), format: :json
        expect(response).to have_http_status 401
      end

      it "return 401 status if invalid access_token" do
        post "/api/v1/questions/#{question.id}/answers", answer: attributes_for(:answer), format: :json, access_token: "12345"
        expect(response).to have_http_status 401
      end
    end

    context "authorized" do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      context "valid attributes" do
        before(:each) { |ex| post "/api/v1/questions/#{question.id}/answers", answer: attributes_for(:answer), format: :json, access_token: access_token.token unless ex.metadata[:skip] }

        it "return 200 status" do
          expect(response).to be_success
        end

        it "save new question", skip_before: true do
          expect{ post "/api/v1/questions/#{question.id}/answers", format: :json, answer: attributes_for(:answer), access_token: access_token.token }.to change(question.answers, :count).by(1)
        end

        %w(id body created_at updated_at).each do |attr|
          it "questions contains #{attr}" do
            expect(response.body).to be_json_eql(assigns(:answer).send(attr.to_sym).to_json).at_path("answer/#{attr}")
          end
        end

        it "add question to user" do
          expect(assigns(:answer).user).to eq me
        end
      end

      context "in-valid attribtues" do
        before(:each) { |ex| post "/api/v1/questions/#{question.id}/answers", answer: attributes_for(:invalid_answer), format: :json, access_token: access_token.token unless ex.metadata[:skip] }

        it "return 422 status" do
          expect(response).to have_http_status 422
        end

        it "not save new question", skip_before: true do
          expect{ post "/api/v1/questions/#{question.id}/answers", answer: attributes_for(:invalid_answer), format: :json, access_token: access_token.token }.to_not change(Answer, :count)
        end

        it "have errors" do
          expect(response.body).to have_json_size(1).at_path("errors")
        end
      end
    end
  end
end
