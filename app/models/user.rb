class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable, omniauth_providers: [:facebook, :twitter]

  has_many  :questions, dependent: :destroy
  has_many  :answers, dependent: :destroy
  has_many  :votes, dependent: :destroy

  def vote_for(voteable)
    votes.find_by(voteable: voteable)
  end
end
