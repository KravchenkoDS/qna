# frozen_string_literal: true

class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user

    return guest_abilities unless user
    user.admin? ? admin_abilities : user_abilities
  end

  def guest_abilities
    can :read, :all
  end

  def user_abilities
    guest_abilities

    can :create, [Question, Answer, Comment]
    can %i[update destroy], [Question, Answer], { user_id: user.id }
    can :best, Answer, question: { user_id: user.id }

    can :destroy, [Link] do |object|
      object.linkable.user_id == user.id
    end

    can :manage, ActiveStorage::Attachment do |file|
      user.author? file.record
    end

    can %i[vote_up vote_down vote_cancel], [Answer, Question] do |object|
      user.author?(object)
    end
  end

  def admin_abilities
    can :manage, :all
  end
end
