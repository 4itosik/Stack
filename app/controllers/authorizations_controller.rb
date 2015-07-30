class AuthorizationsController < ApplicationController
  after_action  :clean_sessiion, only: [:create]

  authorize_resource

  def new
    respond_with(@authorization = Authorization.new)
  end

  def create
    respond_with(@authorization = Authorization.create(authorization_params.merge(provider: session[:auth].first, uid: session[:auth].last)), location: root_path)
  end

  def confirmation
    @authorization = Authorization.not_confirmed.find_by_confirmation_token(params[:confirmation_token])
    if @authorization && @authorization.confirm
      sign_in_and_redirect @authorization.user, event: :authentication
    else
      flash[:error] = "Подтверждаемый email не найден"
      redirect_to root_path
    end
  end

  private
    def authorization_params
      params.require(:authorization).permit(:email)
    end

    def clean_sessiion
      session.delete(:auth) if @authorization.persisted?
    end
end
