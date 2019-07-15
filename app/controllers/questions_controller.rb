class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]

  def new
    @question = current_user.questions.new
  end

  def create
    @question = current_user.questions.new(question_params)
    if @question.save
      redirect_to @question, notice: 'Your question successfully created.'
    else
      render :new
    end
  end

  def index
    @questions = Question.all
  end

  def show
    @question = Question.find(params[:id])
    @answer = @question.answers.new
  end

  def destroy
    @question = Question.find(params[:id])
    if current_user.author?(@question)
      @question.destroy
      redirect_to questions_path
    else
      redirect_to questions_path, alert: 'Access denided'
    end
  end

  private

  def question_params
    params.require(:question).permit(:title, :body)
  end
end
