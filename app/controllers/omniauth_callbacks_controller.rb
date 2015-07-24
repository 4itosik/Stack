class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  before_action :set_user

  def facebook
  end

  def twitter
  end

  private
    def set_user
      if request.env['omniauth.auth']
        @user = User.find_for_oauth(request.env['omniauth.auth'])
        if @user && @user.persisted?
          sign_in_and_redirect @user, event: :authentication
          set_flash_message(:notice, :success, kind: "#{action_name.capitalize}") if is_navigational_format?
        else
          session[:auth] = [request.env['omniauth.auth'].provider, request.env['omniauth.auth'].uid]
          redirect_to new_authorization_path
        end
      end
    end
end