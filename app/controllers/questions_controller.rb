class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question, only: %i[show destroy update]

  def new
    @question = current_user.questions.new
  end

  def show
    @answer = @question.answers.new
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
    @answer = @question.answers.new
  end

  def destroy
    if current_user.author?(@question)
      @question.destroy
      redirect_to questions_path
    else
      redirect_to questions_path, alert: 'Access denided'
    end
  end

  def update
    unless current_user.author?(@question)
      return redirect_to questions_path, alert: 'Access denided'
    end

    @question.update(question_params)
  end

  private

  def load_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body)
  end
end
