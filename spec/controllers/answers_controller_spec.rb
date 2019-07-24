require 'rails_helper'

RSpec.describe AnswersController, type: :controller do

  let(:user) {create(:user)}
  let(:question) {create(:question)}

  describe 'POST #create' do
    before {login(user)}
    context 'with valid attributes' do
      it 'save a new answer in database increment users answers' do
        expect {post :create, params: {question_id: question, answer: attributes_for(:answer)}, format: :js}
            .to change(user.answers, :count).by(1)
      end

      it 'save a new answer in database increment parent question answers' do
        expect {post :create, params: {question_id: question, answer: attributes_for(:answer)}, format: :js}
            .to change(question.answers, :count).by(1)
      end

      it 'renders create template' do
        post :create, params: { answer: attributes_for(:answer), question_id: question, format: :js }
        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      it ' not save a new answer in database' do
        expect {post :create, params: {question_id: question, answer: attributes_for(:answer, :invalid)}, format: :js}
            .to_not change(Answer, :count)
      end

      it 'renders create template' do
        post :create, params: {question_id: question, answer: attributes_for(:answer, :invalid), format: :js}
        expect(response).to render_template :create
      end
    end
  end

  describe 'DELETE #destroy' do
    before {login(user)}
    let!(:answer) {create(:answer)}
    let!(:own_answer) {create(:answer, user: user)}
    context 'Author tried delete question' do
      it 'deletes the answer from  answers' do
        expect {delete :destroy, params: {id: own_answer}, format: :js }.to change(Answer, :count).by(-1)
      end

      it 'renders destroy view' do
        delete :destroy, params:  { id: own_answer }, format: :js
        expect(response).to render_template :destroy
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

  describe 'PATCH #update' do

    let!(:answer) { create(:answer, question: question) }
    let!(:own_answer) { create(:answer, question: question, user: user) }

    context 'with valid attributes' do
      it 'changes answer attributes' do
        patch :update, params: { id: own_answer, answer: { body: 'new body' } }, format: :js

        own_answer.reload

        expect(own_answer.body).to eq 'new body'
      end

      it 'renders update view' do
        patch :update, params: { id: own_answer, answer: { body: 'new body' } }, format: :js

        expect(response).to render_template :update
      end
    end

    context 'with invalid attributes' do
      it 'does not change answer attributes' do
        expect do

          patch :update, params: { id: own_answer, answer: attributes_for(:answer, :invalid) }, format: :js

        end.to_not change(own_answer, :body)
      end

      it 'renders update view' do
        patch :update, params: { id: own_answer, answer: attributes_for(:answer, :invalid) }, format: :js

        expect(response).to render_template :update
      end
    end
    context 'Not author tried update answer' do
      it 'does not change answer attributes' do
        expect do

          patch :update, params: { id: answer }, format: :js

        end.to_not change(answer, :body)
      end
      it 'redirects to question show' do
        patch :update, params: { id: answer, answer: { body: 'new body' } }

        expect(response).to redirect_to question_path(question)
      end
    end
  end

  describe 'PATCH #best' do
    let!(:own_question) { create :question, user: user }

    let!(:answer) { create :answer, question: own_question }

    let(:other_answer) { create :answer }

    context 'Author of question mark answer as best' do
      it 'do attribute best of answers true' do
        patch :best, params: { id: answer }, format: :js

        answer.reload

        expect(answer.best).to be_truthy
      end
      it 'renders best view' do
        patch :best, params: { id: answer }, format: :js

        expect(response).to render_template :best
      end
    end

    context 'Not author of question tried mark answer as best' do
      it 'do not attribute best of answers true' do
        patch :best, params: { id: other_answer }, format: :js

        answer.reload

        expect(answer.best).to be_falsey
      end
    end
  end
end
