require 'rails_helper'

describe AuthorizationsController do
  describe "GET #confirmation" do
    context "search authorization" do
      let(:authorization) { create(:authorization, confirmation_token: "12345678", email: "test@test.ru")}

      before { get :confirmation, confirmation_token: authorization.confirmation_token }

      it "confirmation authorization" do
        expect(assigns(:authorization).confirmation).to eq true
      end

      it "redirect root path" do
        expect(response).to redirect_to root_path
      end
    end

    context "non-search autorization" do
      before { get :confirmation, confirmation_token: "1234" }

      it "redirect root path" do
        expect(response).to redirect_to root_path
      end
    end


  end
end
