class Vote < ApplicationRecord
  belongs_to :votable, polymorphic: true
  belongs_to :user
  validates :user, uniqueness: { scope: :votable, message: 'User cannot vote twice' }
  validate :validate_user_not_author

  VALUE = { up: 1, down: -1 }.freeze

  def up
    update!(value: VALUE[:up])
  end

  def down
    update!(value: VALUE[:down])
  end

  private

  def validate_user_not_author
    errors.add(:user, message: "You can not vote for your answer / question #{votable_type}") if user&.author?(votable)
  end
end
