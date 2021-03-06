require 'rails_helper'

describe "Profile API" do
  describe "/me" do
    it_behaves_like "API Authenticable"

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

    def do_request(options = {})
      get '/api/v1/profiles/me', { format: :json }.merge(options)
    end
  end

  describe "/index" do
    it_behaves_like "API Authenticable"

    context "authorized" do
      let(:me) { create(:user) }
      let!(:users) { create_list(:user, 3) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }
      let(:user) { users.first }

      before { get '/api/v1/profiles', format: :json, access_token: access_token.token }

      it "return 200 status" do
        expect(response).to be_success
      end

      it "contains list of users" do
        expect(response.body).to be_json_eql(users.to_json).at_path("profiles")
      end

      it "contains not have me" do
        expect(response.body).to_not include_json(me.to_json)
      end

      %w(email id created_at updated_at admin).each do |attr|
        it "user contains #{attr}" do
          expect(response.body).to be_json_eql(user.send(attr.to_sym).to_json).at_path("profiles/0/#{attr}")
        end
      end

      %w(password encrypted_password).each do |attr|
        it "user contains #{attr}" do
          expect(response.body).to_not have_json_path("questions/0/#{attr}")
        end
      end
    end

    def do_request(options = {})
      get "/api/v1/profiles", { format: :json }.merge(options)
    end
  end
end