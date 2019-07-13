class QuestionsController < ApplicationController
  def new
    @question = Question.new
  end

  def create
    @question = Question.new(question_params)
    render :new unless @question.save
  end

  private

  def question_params
    params.require(:question).permit(:title, :body)
  end
end
