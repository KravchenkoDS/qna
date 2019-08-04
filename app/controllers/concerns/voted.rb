module Voted
  extend ActiveSupport::Concern
  included do
    before_action :set_votable, only: %i[vote_up vote_down vote_destroy]
    before_action :set_vote, only: %i[vote_up vote_down vote_destroy]
  end

  def vote_up
    @vote.up
    make_response
  end

  def vote_down
    @vote.down
    make_response
  end

  def vote_destroy
    @vote.destroy if current_user.author?(@vote)
    make_response
  end

  private

  def model_klass
    controller_name.classify.constantize
  end

  def set_votable
    @votable = model_klass.find(params[:id])
  end

  def set_vote
    @vote = current_user.votes.find_by(votable: @votable) || Vote.new(user: current_user, votable: @votable)
  end

  private

  def make_response
    respond_to do |format|
      format.json { render_json(@votable) }
    end
  end

  def render_json(item)
    body = { "id": item.id, "score": item.score }
    render json: Hash[param_name(item), body]
  end

  def param_name(item)
    item.class.name.underscore
  end
end
