class Answer < ApplicationRecord
  default_scope {order(best: :desc)}

  belongs_to :question
  belongs_to :user
  #belongs_to :author, class_name: 'User', foreign_key: 'user_id'

  validates :body, presence: true

  def set_best!
    transaction do
      question.answers.where(best: true).update_all(best: false)
      update!(best: true)
    end
  end
end

