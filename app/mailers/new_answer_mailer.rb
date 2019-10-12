class NewAnswerMailer < ApplicationMailer
  def notification(user, answer)
    @answer = answer
    @question = answer.question

    mail to: user.email,
         subject: "New answer for your question"
  end
end
