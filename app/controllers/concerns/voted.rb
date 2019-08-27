module Voted
  extend ActiveSupport::Concern
  included do
    before_action :set_votable, only: %i[vote_up vote_down vote_destroy]
    before_action :set_vote, only: %i[vote_up vote_down vote_destroy]
  end

  def vote_up
    @vote.up
    render json: {
        id: @votable.id,
        score: @votable.score,
        type: @votable.class.name.underscore
    }
  end

  def vote_down
    @vote.down
    render json: {
        id: @votable.id,
        score: @votable.score,
        type: @votable.class.name.underscore
    }
  end

  def vote_destroy
    @vote.destroy if current_user.author?(@vote)
    make_response
  end

  private

  def set_votable
    model_klass = controller_name.classify.constantize
    @votable = model_klass.find(params[:id])
  end

  def set_vote
    @vote = current_user.votes.find_by(votable: @votable) || Vote.new(user: current_user, votable: @votable)
  end
end
