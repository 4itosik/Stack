class DailyMailer < ApplicationMailer
  def digest(user)
    @user = user
    @questions = Question.previous_day

    mail to: @user.email, subject: "Новые вопросы за вчерашний день"
  end
end
