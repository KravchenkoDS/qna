# frozen_string_literal: true

class AnswersController < ApplicationController
  include Voted

  before_action :authenticate_user!
  before_action :load_question, only: %i[new create]
  before_action :load_answer, only: %i[update destroy best]
  after_action :publish_answer, only: :create

  expose :comment, -> { answer.comments.new }

  def edit; end

  def update
    unless current_user.author?(@answer)
      return redirect_to question_path(@answer.question), alert: 'Access denided'
    end

    @answer.update(answers_params)
    @question = @answer.question
  end

  def create
    @answer = @question.answers.new(answers_params)
    @answer.user = current_user
    @answer.save
  end

  def destroy
    unless current_user.author?(@answer)
      return redirect_to question_path(@answer.question), alert: 'Access denided'
    end

    @answer.destroy
  end

  def best
    @question = @answer.question
    if current_user.author?(@question)
      @answer.set_best!
    else
      return redirect_to question_path(@question), alert: 'Access denided'
    end
  end

  private

  def publish_answer
    return if @answer.errors.any?

    AnswersChannel.broadcast_to(answer.question, answer: answer,
        links: answer.links, files: answer.files.map { |file| { id: file.id, name: file.filename.to_s, url: url_for(file) } }
    )
  end

  def load_question
    @question = Question.find(params[:question_id])
  end

  def load_answer
    @answer = Answer.with_attached_files.find(params[:id])
  end

  def answers_params
    params.require(:answer).permit(:body, files: [], links_attributes: [:name, :url])
  end
end
