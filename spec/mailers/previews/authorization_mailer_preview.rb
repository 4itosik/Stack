# Preview all emails at http://localhost:3000/rails/mailers/authorization_mailer
class AuthorizationMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/authorization_mailer/confirmation_mail
  def confirmation_mail(authorization)
    @authorization = authorization

    AuthorizationMailer.confirmation_mail(@authorization)
  end

end
