class AnswersController < ApplicationController
  before_action :load_question, only: %i[new create]
  before_action :load_answer, only: %i[destroy]
  before_action :authenticate_user!

  def create
    @answer = @question.answers.new(answers_params)
    @answer.user = current_user
    if @answer.save
      redirect_to question_path(@answer.question), notice: 'Your answer successfully created.'
    else
      render 'questions/show', alert: 'Only the owner can delete the response.'
    end
  end

  def destroy
    @answer = Answer.find(params[:id])
    if current_user.author?(@answer)
      @answer.destroy
      redirect_to question_path(@answer.question)
    else
      redirect_to question_path(@answer.question), alert: 'Access denided'
    end
  end

  private

  def load_question
    @question = Question.find(params[:question_id])
  end

  def load_answer
    @answer = Answer.find(params[:id])
  end

  def answers_params
    params.require(:answer).permit(:body)
  end
end

