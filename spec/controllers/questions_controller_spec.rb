require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  describe 'GET #new' do
    before {get :new}

    it 'assigns a new Question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do

    context 'with valid attributes' do
      it 'save a new question in database' do
        expect {post :create, params: {question: attributes_for(:question)}}.to change(Question, :count).by(1)
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
end
