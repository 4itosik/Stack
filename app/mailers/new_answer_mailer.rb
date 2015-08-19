class NewAnswerMailer < ApplicationMailer
  def information(question, user, answer)
    @question = question
    @user = user
    @answer = answer

    mail to: @user.email, subject: "Новый ответ на"
  end
end
