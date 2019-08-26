# frozen_string_literal: true

class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    if user
      user.admin? ? admin_abilities : user_abilities
    else
      guest_abilities
    end
  end

  def guest_abilities
    can :read, :all
  end

  def user_abilities
    guest_abilities
    #cannot?
    can :create, [Question, Answer, Comment]
    can :update, [Question, Answer], user_id: user.id
    can :destroy, [Question, Answer], user_id: user.id
    can :best, Answer, question: {user_id: user.id}
    can :vote_destroy, [Question, Answer], votes: {user_id: user.id}
    can [:create, :destroy], Link, linkable: {user_id: user.id}
    can :create, Award, question: {user_id: user.id}
    can [:vote_up, :vote_down], [Question, Answer] do |item|
      !user.author? item
    end
    can :manage, ActiveStorage::Attachment do |file|
      user.author? file.record
    end
  end

  def admin_abilities
    can :manage, :all
  end
end
