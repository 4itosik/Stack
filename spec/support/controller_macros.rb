module ControllerMacros
  def login_user
    before do
      @user = create(:user)
      sign_in :user, @user
    end
  end
end

