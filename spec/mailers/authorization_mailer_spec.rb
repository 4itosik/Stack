require "rails_helper"

RSpec.describe AuthorizationMailer, type: :mailer do
  describe "confirmation_mail" do
    let(:authorization) { create(:authorization, email: "test@test.ru", confirmation_token: "12345678") }
    let(:mail) { AuthorizationMailer.confirmation_mail(authorization) }

    it "renders the headers" do
      expect(mail.subject).to eq("Подтверждение пароля")
      expect(mail.to).to eq([authorization.email])
      expect(mail.from).to eq(["from@example.com"])
    end
  end

end
