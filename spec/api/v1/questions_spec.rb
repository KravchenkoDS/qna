require 'rails_helper'

describe 'Questions API', type: :request do
  let(:headers) { { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' } }
  let(:access_token) { create(:access_token) }

  describe 'GET /api/v1/questions' do
    let(:api_path) { '/api/v1/questions' }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
      let(:params) { { access_token: access_token.token } }
    end

    context 'authorized' do
      let!(:questions) { create_list(:question, 2) }
      let(:question) { questions.first }
      let(:question_response) { json['questions'].first }
      let!(:answers) { create_list(:answer, 3, question: question)}

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it 'return list of questions' do
        expect(json['questions'].size).to eq 2
      end

      it 'returns all public fields' do
        %w[id title body created_at updated_at].each do |attr|
          expect(question_response[attr]).to eq question.send(attr).as_json
        end
      end

      describe 'author' do
        it 'returns all public fields' do
          %w[id email created_at updated_at].each do |attr|
            expect(question_response['author'][attr]).to eq question.author.send(attr).as_json
          end
        end
      end

      describe 'answers' do
        let(:answer) { answers.first }
        let(:answer_response) { question_response['answers'].first }

        it 'return list of answers' do
          expect(question_response['answers'].size).to eq 3
        end

        it 'returns all public fields' do
          %w[id body created_at updated_at].each do |attr|
            expect(answer_response[attr]).to eq answer.send(attr).as_json
          end
        end
      end
    end
  end

  describe 'GET /api/v1/questions/:id' do
    let!(:question) { create(:question, :with_link, :with_file, :with_comment)}
    let(:api_path) { "/api/v1/questions/#{question.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
      let(:params) { { access_token: access_token.token } }
    end

    context 'authorized' do
      let(:question_response) { json['question']}

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it 'returns all public fields' do
        %w[id title body created_at updated_at].each do |attr|
          expect(question_response[attr]).to eq question.send(attr).as_json
        end
      end

      describe 'author' do
        it 'returns all public fields' do
          %w[id email created_at updated_at].each do |attr|
            expect(question_response['author'][attr]).to eq question.author.send(attr).as_json
          end
        end
      end

      describe 'links' do
        it_behaves_like 'API Listable' do
          let(:list_response) { question_response['links'] }
          let(:list) { question.links }
          let(:fields) { %w[id name url created_at updated_at] }
        end
      end

      describe 'comments' do
        it_behaves_like 'API Listable' do
          let(:list_response) { question_response['comments'] }
          let(:list) { question.comments }
          let(:fields) { %w[id body user_id created_at updated_at] }
        end
      end

      describe 'files' do
        let(:file_response) { question_response['files'].first }
        let(:file) { question.files.first }

        it 'return list of files' do
          expect(question_response['files'].size).to eq question.files.size
        end

        it 'returns  public fields' do
          expect(file_response['id']).to eq file.id
          expect(file_response['filename']).to eq file.filename.to_s
          expect(file_response['url']).to eq url_for(file)
        end
      end
    end
  end

  describe 'POST /api/v1/questions' do
    it_behaves_like 'API Creatable' do
      let(:method) { :post }
      let(:params) { { question: attributes_for(:question), access_token: access_token.token } }

      let(:bad_params) { { question: { title: '' }, access_token: access_token.token } }

      let(:klass) { Question }
      let(:api_path) { "/api/v1/questions" }
    end
  end

  describe 'PATCH /api/v1/questions/:id' do
    it_behaves_like 'API Updatable' do
      let(:method) { :patch }
      let(:params) { { question: { title: 'New title' }, access_token: access_token.token } }

      let(:bad_params) { { question: { title: '' }, access_token: access_token.token } }

      let(:resource) { create(:question) }
      let(:api_path) { "/api/v1/questions/#{resource.id}" }
      let(:updated_attribute) { 'title' }
      let(:updated_value) { 'New title' }
    end
  end

  describe 'DELETE /api/v1/questions/:id' do
    it_behaves_like 'API Deletable' do
      let(:resource) { create(:question) }
      let(:api_path) { "/api/v1/questions/#{resource.id}" }
    end
  end
end
