class Answer < ApplicationRecord

  include Votable
  include Commentable

  default_scope {order(best: :desc)}

  has_many :links, dependent: :destroy, as: :linkable
  belongs_to :question
  belongs_to :user

  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank

  after_create :subscription_job

  validates :body, presence: true

  def set_best!
    transaction do
      question.answers.where(best: true).update_all(best: false)
      update!(best: true)
      award = question.award
      user.awards << award unless award.nil?
    end
  end

  def subscription_job
    NewAnswersJob.perform_later(self)
  end
end

