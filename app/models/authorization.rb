class Authorization < ActiveRecord::Base
  scope :confirmed, -> { where(confirmation: true) }
  scope :not_confirmed, -> { where(confirmation: false) }

  belongs_to  :user

  validates   :uid, :provider, presence: true
  validates   :user, presence: true, if: :confirmation
  validates   :email, presence: true, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, on: :create }, unless: :confirmation
  validates   :confirmation_token, presence: true, unless: :confirmation

  before_validation :generate_token, on: :create, unless: :confirmation
  after_create  :send_mail, unless: :confirmation

  def confirm
    transaction do
      user = User.find_by_email(email)
      if user.nil?
        password = Devise.friendly_token[0, 20]
        user = User.create!(email: email, password: password, password_confirmation: password)
      end
      self.update!(confirmation: true, confirmation_token: nil, user: user)
      Authorization.remove_duplicate_emails(email)
    end
  end

  def self.remove_duplicate_emails(email)
    not_confirmed.where(email: email).each {|el| el.destroy}
  end

  private

    def generate_token
      begin
        self.confirmation_token = SecureRandom.urlsafe_base64
      end while Authorization.exists?(confirmation_token: self.confirmation_token)
    end

    def send_mail
      AuthorizationMailer.confirmation_mail(self).deliver_now
    end

end
