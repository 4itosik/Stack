class AuthorizationMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.authorization_mailer.confirmation_mail.subject
  #
  def confirmation_mail(authorization)
    @authorization = authorization

    mail to: @authorization.email, subject: "Подтверждение пароля"
  end
end
