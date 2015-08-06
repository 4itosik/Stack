class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user

    if user
      user.admin? ? admin_abilities : user_abilities
    else
      guest_abilities
    end
  end

  def guest_abilities
    alias_action  :create, :confirmation, to: :confirm

    can :read, :all
    can :confirm, Authorization
  end

  def admin_abilities
    can :manage, :all
  end

  def user_abilities
    guest_abilities

    alias_action  :create, :read, :update, :destroy, to: :crud

    can :crud, [Question, Answer], user: user

    can :create, Comment

    can :manage, :profile

    can :manage, Attachment do |attachment|
      user.owner?(attachment.attachable)
    end

    can :best, Answer do |answer|
      user.owner?(answer.question) && answer.best == false
    end

    can :cancel_best, Answer do |answer|
      user.owner?(answer.question) && answer.best == true
    end

    can :vote, [Answer, Question] do |voteable|
      !user.owner?(voteable) && !voteable.voted_by?(user)
    end

    can :cancel_vote, [Answer, Question] do |voteable|
      !user.owner?(voteable) && voteable.voted_by?(user)
    end

  end
end
