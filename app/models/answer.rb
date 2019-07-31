class Answer < ApplicationRecord
  default_scope {order(best: :desc)}

  has_many :links, dependent: :destroy, as: :linkable
  belongs_to :question
  belongs_to :user

  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank

  validates :body, presence: true

  def set_best!
    transaction do
      question.answers.where(best: true).update_all(best: false)
      update!(best: true)
      award = question.award
      user.awards << award unless award.nil?
    end
  end
end

