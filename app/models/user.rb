class User < ApplicationRecord
  has_many :answers, dependent: :destroy
  has_many :questions, dependent: :destroy
  has_many :awards, dependent: :destroy
  has_many :votes, dependent: :destroy
  has_many :authorizations, dependent: :destroy
  has_many :subscriptions, dependent: :destroy

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable,:omniauthable,
         omniauth_providers: [:github, :mail_ru, :vkontakte]

  def author?(resource)
    resource.user_id == id
  end

  def confirmation_required?
    false
  end

  def self.find_for_oauth(auth)
    Services::FindForOauth.new(auth).call
  end

=begin
  def subscribed_to?(resource)
    subscriptions.find_by(question_id: resource.id).present?
  end
=end

  def subscribed?(question)
    !!subscription(question)
  end

  def subscription(question)
    subscriptions.find_by(question_id: question.id)
  end
end
