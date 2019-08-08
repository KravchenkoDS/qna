require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do

  it_behaves_like 'voted'

  let(:user) {create(:user)}

  describe 'GET #new' do
    before {login(user)}

    it 'assigns a new Question to @question' do
      expect {get :new, params: {question_id: question, answer: attributes_for(:question)}}
    end

    it 'renders new view' do
      get :new, params: {question: attributes_for(:question)}
      expect(response).to render_template :new
    end
  end

  describe 'GET #index' do
    let(:questions) {create_list(:question, 3)}

    before {get :index}

    it 'populates an array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    before {login(user)}
    let(:question) {create(:question)}
    let(:answer) {create(:answer, question_id: question)}

    before {get :show, params: {id: question}}

    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'assigns a new Answers to @answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'POST #create' do
    before {login(user)}
    context 'Author create question with valid attributes' do
      it 'save a new question in database' do
        expect {post :create, params: {question: attributes_for(:question)}}.to change(user.questions, :count).by(1)
      end

      it 'redirects to show view' do
        post :create, params: {question: attributes_for(:question)}
        expect(response).to redirect_to assigns(:question)
      end
    end

    context 'with invalid attributes' do
      it ' not save question in database' do
        expect {post :create, params: {question: attributes_for(:question, :invalid)}}.to_not change(Question, :count)
      end

      it 're-render new view' do
        post :create, params: {question: attributes_for(:question, :invalid)}
        expect(response).to render_template :new
      end
    end
  end

  describe 'DELETE #destroy' do

    before {login(user)}

    let!(:question) {create(:question)}

    let!(:own_question) {create(:question, user: user)}

    context 'Author tried delete question' do
      it 'deletes the question' do

        expect {delete :destroy, params: {id: own_question}}.to change(Question, :count).by(-1)

      end

      it 'redirects to index' do
        delete :destroy, params: {id: own_question}

        expect(response).to redirect_to questions_path
      end
    end
    context ' Not author tried delete question' do
      it 'deletes the question' do

        expect {delete :destroy, params: {id: question}}.to_not change(Question, :count)

      end

      it 'redirects to index' do
        delete :destroy, params: {id: question}

        expect(response).to redirect_to questions_path
      end
    end
  end
  describe 'PATCH #update' do

    let!(:question) { create(:question) }

    let!(:own_question) { create(:question, user: user) }

    context 'with valid attributes' do
      it 'renders update view' do
        patch :update, params: { id: own_question, question: { body: 'new body' } }, format: :js

        expect(response).to render_template :update
      end

      it 'changes question attributes' do
        patch :update, params: { id: question, question: { title: 'new title', body: 'new body' }, format: :js }

        question.reload

        expect(question.title).to eq 'new title'

        expect(question.body).to eq 'new body'
      end
    end

    context 'with invalid attributes' do
      it 'does not change question attributes' do
        expect do

          patch :update, params: { id: own_question, question: attributes_for(:question, :invalid) }, format: :js
          
          question.reload

        end.to_not change(own_question, :body)
      end

      it 'renders update view' do
        patch :update, params: { id: own_question, question: attributes_for(:question, :invalid) }, format: :js

        expect(response).to render_template :update
      end
    end
    context 'Not author tried update question' do
      it 'redirects to index' do
        patch :update, params: { id: question, question: { body: 'new body' } }, format: :js

        expect(response).to redirect_to questions_path
      end

      it 'does not change question attributes' do
        expect do

          patch :update, params: { id: question, question: { body: 'new body' } }, format: :js
          question.reload
        end.to_not change(question, :body)
      end
    end
  end
end
