require 'rails_helper'

describe "Questions API" do
  describe "/index" do
    context "unauthorized" do
      it "return 401 status if there is no access_token" do
        get "/api/v1/questions", format: :json
        expect(response).to have_http_status 401
      end

      it "return 401 status if invalid access_token" do
        get "/api/v1/questions", format: :json, access_token: "12345"
        expect(response).to have_http_status 401
      end
    end

    context "authorized" do
      let(:access_token) { create(:access_token) }
      let!(:question) { create(:question) }
      let!(:old_question) { create(:question, created_at: 2.days.ago) }

      before { get '/api/v1/questions', format: :json, access_token: access_token.token }

      it "return 200 status" do
        expect(response).to be_success
      end

      it "contains list of questions" do
        expect(response.body).to have_json_size(2).at_path("questions")
      end

      %w(id title body created_at updated_at).each do |attr|
        it "questions contains #{attr}" do
          expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("questions/0/#{attr}")
        end
      end
    end
  end


  describe "/show" do
    let(:question) { create(:question) }

    context "unauthorized" do
      it "return 401 status if there is no access_token" do
        get "/api/v1/questions/#{question.id}", format: :json
        expect(response).to have_http_status 401
      end

      it "return 401 status if invalid access_token" do
        get "/api/v1/questions/#{question.id}", format: :json, access_token: "12345"
        expect(response).to have_http_status 401
      end
    end

    context "authorized" do
      let!(:comment) { create(:comment, commentable: question) }
      let!(:attachment) { create(:attachment, attachable: question) }

      let(:access_token) { create(:access_token) }

      before { get "/api/v1/questions/#{question.id}", format: :json, access_token: access_token.token }

      it "return 200 status" do
        expect(response).to be_success
      end

      %w(id title body created_at updated_at).each do |attr|
        it "questions contains #{attr}" do
          expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("question/#{attr}")
        end
      end

      context "comments" do
        it 'included in question object' do
          expect(response.body).to have_json_size(1).at_path("question/comments")
        end

        %w(id body).each do |attr|
          it "contains #{attr}" do
            expect(response.body).to be_json_eql(comment.send(attr.to_sym).to_json).at_path("question/comments/0/#{attr}")
          end
        end
      end

      context "attachments" do
        it 'included in question object' do
          expect(response.body).to have_json_size(1).at_path("question/attachments")
        end


        it "contains url" do
          expect(response.body).to be_json_eql(attachment.file.url.to_json).at_path("question/attachments/0/url")
        end
      end
    end
  end

  describe "/create" do
    context "unauthorized" do
      it "return 401 status if there is no access_token" do
        post "/api/v1/questions", question: attributes_for(:question), format: :json
        expect(response).to have_http_status 401
      end

      it "return 401 status if invalid access_token" do
        post "/api/v1/questions", question: attributes_for(:question), format: :json, access_token: "12345"
        expect(response).to have_http_status 401
      end
    end

    context "authorized" do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      context "valid attributes" do
        before(:each) { |ex| post "/api/v1/questions", question: attributes_for(:question), format: :json, access_token: access_token.token unless ex.metadata[:skip] }

        it "return 200 status" do
          expect(response).to be_success
        end

        it "save new question", skip_before: true do
          expect{ post "/api/v1/questions", format: :json, question: attributes_for(:question), access_token: access_token.token }.to change(Question, :count).by(1)
        end

        %w(id title body created_at updated_at).each do |attr|
          it "questions contains #{attr}" do
            expect(response.body).to be_json_eql(assigns(:question).send(attr.to_sym).to_json).at_path("question/#{attr}")
          end
        end

        it "add question to user" do
          expect(assigns(:question).user).to eq me
        end
      end

      context "in-valid attribtues" do
        before(:each) { |ex| post "/api/v1/questions", question: attributes_for(:invalid_question), format: :json, access_token: access_token.token unless ex.metadata[:skip] }

        it "return 422 status" do
          expect(response).to have_http_status 422
        end

        it "not save new question", skip_before: true do
          expect{ post "/api/v1/questions", question: attributes_for(:invalid_question), format: :json, access_token: access_token.token }.to_not change(Question, :count)
        end

        it "have errors" do
          expect(response.body).to have_json_size(2).at_path("errors")
        end
      end
    end
  end
end