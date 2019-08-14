class QuestionsController < ApplicationController
  include Voted

  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question, only: %i[show destroy update]
  after_action :publish_question, only: :create

  expose :comment, -> { @question.comments.new }

  def new
    @question = current_user.questions.new
  end

  def show
    @answer = @question.answers.new
    @question.build_award
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

  def publish_question
    return if @question.errors.any?

    ActionCable.server.broadcast('questions', question: @question,
        links: @question.links, files: @question.files.map { |file| { id: file.id, name: file.filename.to_s, url: url_for(file) } }
    )
  end

  def load_question
    @question = Question.with_attached_files.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body, files: [],
                           award_attributes: [:title, :image],
                           links_attributes: [:name, :url])
  end
end
