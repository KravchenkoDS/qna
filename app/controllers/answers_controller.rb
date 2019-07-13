class AnswersController < ApplicationController
  def new
    @answer = question.answers.new
  end

  def create
    @answer = question.answers.new(answers_params)
    render :new unless @answer.save
  end

  private

  def question
    @question ||= Question.find(params[:question_id])
  end

  def answers_params
    params.require(:answer).permit(:body)
  end
end
