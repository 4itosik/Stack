require 'rails_helper'

describe Authorization do
  it { should validate_presence_of :provider }
  it { should validate_presence_of :uid }

  context "if confirmation" do
    before { allow(subject).to receive(:confirmation).and_return(true) }

    it { should validate_presence_of :user }
  end

  context "if not confirmation" do
    before { allow(subject).to receive(:confirmation).and_return(false) }

    it { should validate_presence_of :email }
    it { should_not allow_value("test@test").for(:email) }
  end

  describe "validates confirmation token" do
    context "if confirmation" do
      let(:authorization) { build(:confirmed) }

      it { expect(authorization).to be_valid }
    end

    context "if not confirmation" do
      it "not valid" do
        authorization = build(:authorization, confirmation_token: nil)

        expect(authorization).to_not be_valid
      end

      it "valid" do
        authorization = build(:non_confirmed)

        expect(authorization).to be_valid
      end
    end
  end

  it { should belong_to :user }

  describe "#confirm" do
    let(:authorization) { create(:non_confirmed) }

    context "update authorization" do
      before(:each) { |ex| authorization.confirm unless ex.metadata[:skip] }

      it "confirmed authorization" do
        expect(authorization.confirmation).to eq true
      end

      it "clear confirmation token" do
        expect(authorization.confirmation_token).to be_nil
      end

      it "remove other authorizations", skip_before: true do
        create_list(:non_confirmed, 3)
        authorization.confirm

        expect(Authorization.all.length).to eq 1
      end

      it "add user to authorization" do
        expect(authorization.user).to be_truthy
      end
    end

    context "exists user" do
      let!(:user) { create(:user, email: "test@test.ru") }

      it "does not create new user" do
        expect{ authorization.confirm }.to_not change(User, :count)
      end

      it "add authorization for user" do
        authorization.confirm

        expect(user.authorizations.first).to eq authorization
      end
    end

    context "non-exists user" do
      it "create new user" do
        expect{ authorization.confirm }.to change(User, :count).by(1)
      end

      it "fills new user" do
        authorization.confirm

        expect(authorization.user.email).to eq "test@test.ru"
      end

      it "add authorization for user" do
        authorization.confirm
        user = User.last

        expect(user.authorizations.first).to eq authorization
      end
    end
  end

  describe ".remove_duplicate_emails" do
    context "not confirmed" do
      let(:authorization) { create(:non_confirmed) }

      before do
        create_list(:non_confirmed, 3)
        Authorization.remove_duplicate_emails(authorization.email)
      end

      it "remove all" do
        expect(Authorization.all.length).to eq 0
      end
    end

    context "confirmed" do
      let(:authorization) { create(:confirmed, email: "test@test.ru") }

      before do
        create_list(:non_confirmed, 3)
        Authorization.remove_duplicate_emails(authorization.email)
      end

      it "remove only not confirmed" do
        expect(Authorization.all.length).to eq 1
      end
    end
  end
end
