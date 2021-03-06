# frozen_string_literal: true

class Api::V1::QuestionsController < Api::V1::BaseController
  load_and_authorize_resource

  def index
    questions = Question.all
    render json: questions
  end

  def show
    render json: question
  end

  def create
    question = Question.create(question_params)
    question.author = current_resource_owner

    if question.save
      render json: question, status: :created
    else
      render json: { errors: question.errors }, status: :unprocessable_entity
    end
  end

  def update
    if question.update(question_params)
      render json: question, status: :created
    else
      render json: { errors: question.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    if question.destroy!
      render json: {}, status: :ok
    else
      render json: { errors: question.errors }, status: :unprocessable_entity
    end
  end

  private

  def question
    @question ||= Question.with_attached_files.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body)
  end
end
