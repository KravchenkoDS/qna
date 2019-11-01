class DailyDigestMailer < ApplicationMailer
  def digest(user)
    #@questions = Question.where('created_at > ?', 1.day.ago)
    @questions = Question.where('created_at > ?', 1.minute.ago)

    mail to: user.email
  end
end
