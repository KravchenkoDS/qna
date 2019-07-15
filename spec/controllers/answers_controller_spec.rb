require 'rails_helper'

RSpec.describe AnswersController, type: :controller do

  let(:user) {create(:user)}
  let(:question) {create(:question)}
  before {login(user)}

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'save a new answer in database increment users answers' do
        expect {post :create, params: {question_id: question, answer: attributes_for(:answer)}}
            .to change(user.answers, :count).by(1)
      end

      it 'save a new answer in database increment parent question answers' do
        expect {post :create, params: {question_id: question, answer: attributes_for(:answer)}}
            .to change(question.answers, :count).by(1)
      end

      it 'redirects to show question view' do
        post :create, params: {question_id: question, answer: attributes_for(:answer)}
        expect(response).to redirect_to question
      end
    end

    context 'with invalid attributes' do
      it ' not save a new answer in database' do
        expect {post :create, params: {question_id: question, answer: attributes_for(:answer, :invalid)}}
            .to_not change(Answer, :count)
      end

      it 're-render to show question view' do
        post :create, params: {question_id: question, answer: attributes_for(:answer, :invalid)}
        expect(response).to render_template 'questions/show'
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:answer) {create(:answer)}
    let!(:own_answer) {create(:answer, user: user)}
    context 'Author tried delete question' do
      it 'deletes the answer from  answers' do
        expect {delete :destroy, params: {id: own_answer}}.to change(Answer, :count).by(-1)
      end

      it 'redirects to question show' do
        delete :destroy, params: {id: own_answer}
        expect(response).to redirect_to question_path(own_answer.question)
      end
    end

    context ' Not author tried delete question' do
      it 'deletes the question' do
        expect {delete :destroy, params: {id: answer}}.to_not change(Answer, :count)
      end

      it 'redirects to index' do
        delete :destroy, params: {id: answer}
        expect(response).to redirect_to question_path(answer.question)
      end
    end
  end
end
