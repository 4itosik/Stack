require 'rails_helper'

describe "Profile API" do
  describe "/me" do
    context "unauthorized" do
      it "return 401 status if there is no access_token" do
        get "/api/v1/profiles/me", format: :json
        expect(response).to have_http_status 401
      end

      it "return 401 status if invalid access_token" do
        get "/api/v1/profiles/me", format: :json, access_token: "12345"
        expect(response).to have_http_status 401
      end
    end

    context "authorized" do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      before { get '/api/v1/profiles/me', format: :json, access_token: access_token.token }

      it "return 200 status" do
        expect(response).to be_success
      end

      %w(email id created_at updated_at admin).each do |attr|
        it "contains #{attr}" do
          expect(response.body).to be_json_eql(me.send(attr.to_sym).to_json).at_path(attr)
        end
      end

      %w(password encrypted_password).each do |attr|
        it "does not contain #{attr}" do
          expect(response.body).to_not have_json_path(attr)
        end
      end
    end
  end

  describe "/index" do
    context "unauthorized" do
      it "return 401 status if there is no access_token" do
        get "/api/v1/profiles", format: :json
        expect(response).to have_http_status 401
      end

      it "return 401 status if invalid access_token" do
        get "/api/v1/profiles", format: :json, access_token: "12345"
        expect(response).to have_http_status 401
      end
    end

    context "authorized" do
      let(:me) { create(:user) }
      let!(:users) { create_list(:user, 3) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      before { get '/api/v1/profiles', format: :json, access_token: access_token.token }

      it "return 200 status" do
        expect(response).to be_success
      end

      it "contains list of users" do
        expect(response.body).to be_json_eql(users.to_json)
      end

      it "contains not have me" do
        expect(response.body).to_not include_json(me.to_json)
      end

      %w(email id created_at updated_at admin).each do |attr|
        it "user contains #{attr}" do
          users.each_with_index do |user, index|
            expect(response.body).to be_json_eql(user.send(attr.to_sym).to_json).at_path("#{index}/#{attr}")
          end
        end
      end

      %w(password encrypted_password).each do |attr|
        it "user contains #{attr}" do
          users.each_with_index do |user, index|
            expect(response.body).to_not have_json_path("#{index}/#{attr}")
          end
        end
      end
    end
  end
end