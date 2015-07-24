class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable, omniauth_providers: [:facebook, :twitter]

  has_many  :questions, dependent: :destroy
  has_many  :answers, dependent: :destroy
  has_many  :votes, dependent: :destroy
  has_many  :authorizations, dependent: :destroy

  def vote_for(voteable)
    votes.find_by(voteable: voteable)
  end

  def self.find_for_oauth(auth)
    authorization = Authorization.confirmed.where(provider: auth.provider, uid: auth.uid.to_s).first
    return authorization.user if authorization

    email = auth.info[:email]
    return nil if email.nil?
    user = User.find_by_email(email)
    if user
      user.authorizations.create(provider: auth.provider, uid: auth.uid.to_s, confirmation: true)
    else
      password = Devise.friendly_token[0, 20]
      user = User.create!(email: email, password: password, password_confirmation: password)
      user.authorizations.create(provider: auth.provider, uid: auth.uid.to_s, confirmation: true)
    end
    user
  end
end
