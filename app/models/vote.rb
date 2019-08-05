class Vote < ApplicationRecord
  belongs_to :votable, polymorphic: true
  belongs_to :user
  validates :user, uniqueness: { scope: :votable, message: 'User cannot vote twice' }
  validate :validate_user_not_author

  def up
    update!(value: 1)
  end

  def down
    update!(value: -1)
  end

  private

  def validate_user_not_author
    errors.add(:user, message: "You can not vote for your answer / question #{votable_type}") if user&.author?(votable)
  end
end
