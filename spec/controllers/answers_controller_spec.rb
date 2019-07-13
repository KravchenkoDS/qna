require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) {create(:question)}
  let(:answer) {create(:answer, question_id: question)}

  describe 'GET #new' do

    it 'assigns a new Answers to @answer' do
      expect {post :new, params: {question_id: question, answer: attributes_for(:answer)}}
    end

    it 'renders new view' do
      post :create, params: {question_id: question, answer: attributes_for(:answer, :invalid)}
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'save a new answer in database' do
        expect {post :create, params: {question_id: question, answer: attributes_for(:answer)}}
            .to change(question.answers, :count).by(1)
      end
    end

    context 'with invalid attributes' do
      it ' not save a new answer in database' do
        expect {post :create, params: {question_id: question, answer: attributes_for(:answer, :invalid)}}
            .to_not change(Answer, :count)
      end

      it 're-render new view' do
        post :create, params: {question_id: question, answer: attributes_for(:answer, :invalid)}
        expect(response).to render_template :new
      end
    end
  end
end
