require 'rails_helper'

RSpec.shared_examples 'voted' do
  let(:model_klass) { described_class.controller_name.singularize.to_sym }
  let!(:model) { create(model_klass) }
  let(:user) { create(:user) }
  let!(:owned_model) { create(model_klass, user: user) }

  describe 'POST #vote_up' do

    context 'Authenticated user' do
      before { login(user) }

      context 'with valid attributes' do
        it 'can vote' do
          expect { post :vote_up, params: { id: model }, format: :json }.to change(model.votes, :count).by(1)
          expect(model.votes.last.value).to eq(1)
        end

        it 'render json' do
          post :vote_up, params: { id: model }, format: :json
          json_response = JSON.parse(response.body)

          expect(json_response['model']).to eq model.class.name.underscore
          expect(json_response['object_id']).to eq model.id
          expect(json_response['value']).to eq 1
        end

        it "vote twice" do
          2.times { post :vote_up, params: { id: model }, format: :json }
          json_response = JSON.parse(response.body)

          expect(response.status).to eq 422
          expect(json_response['value']).to eq ["You can't vote twice"]
        end
      end

      context 'with owner votable' do
        it "can't vote" do
          expect { post :vote_up, params: { id: owned_model }, format: :json }.to_not change(owned_model.votes, :count)
        end

        it 'render json' do
          post :vote_up, params: { id: owned_model }, format: :json
          json_response = JSON.parse(response.body)

          expect(response.status).to eq 422
          expect(json_response['user']).to eq ["You can not vote for your answer / question"]
        end
      end
    end

    context 'Unauthenticated user' do
      before { logout(user) }

      it "can't vote" do
        expect { post :vote_up, params: { id: model }, format: :json }.to_not change(model.votes, :count)
      end

      it 'status 401' do
        post :vote_up, params: { id: model }, format: :json

        expect(response).to have_http_status(401)
      end
    end
  end

  describe 'POST #vote_down' do
    context 'Authenticated user' do
      before { login(user) }

      context 'with valid attributes' do
        it 'can vote' do
          expect { post :vote_down, params: { id: model }, format: :json }.to change(model.votes, :count).by(1)
          expect(model.votes.last.value).to eq(-1)
        end

        it 'render json' do
          post :vote_down, params: { id: model }, format: :json
          json_response = JSON.parse(response.body)

          expect(json_response['model']).to eq model.class.name.underscore
          expect(json_response['object_id']).to eq model.id
          expect(json_response['value']).to eq(-1)
        end

        it "can't vote twice" do
          2.times { post :vote_up, params: { id: model }, format: :json }
          json_response = JSON.parse(response.body)

          expect(response.status).to eq 422
          expect(json_response['value']).to eq ["You can't vote twice"]
        end
      end

      context 'with owner votable' do
        it "can't vote" do
          expect { post :vote_down, params: { id: owned_model }, format: :json }.to_not change(owned_model.votes, :count)
        end

        it 'render json' do
          post :vote_down, params: { id: owned_model }, format: :json
          json_response = JSON.parse(response.body)

          expect(response.status).to eq 422
          expect(json_response['user']).to eq ["You can not vote for your answer / question"]
        end
      end
    end

    context 'Unauthenticated user' do
      before { logout(user) }

      it "can't vote" do
        expect { post :vote_up, params: { id: model }, format: :json }.to_not change(model.votes, :count)
      end

      it 'status 401' do
        post :vote_up, params: { id: model }, format: :json

        expect(response).to have_http_status(401)
      end
    end
  end
end
