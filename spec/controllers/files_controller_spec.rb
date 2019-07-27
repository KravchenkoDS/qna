require 'rails_helper'

RSpec.describe FilesController, type: :controller do

  let(:user) { create(:user) }
  before { login(user) }

  describe 'DELETE #destroy' do
    let!(:file) { fixture_file_upload("#{Rails.root}/spec/rails_helper.rb") }

    context 'author tried delete file' do
      let(:own_answer) { create(:answer, user: user, files: file) }
      it 'deletes the file from  answers files' do
        expect { delete :destroy, params: { id: own_answer.files.first}, format: :js }
            .to change(own_answer.files, :count).by(-1)
      end

      it 'renders destroy view' do
        delete :destroy, params:  { id: own_answer.files.first }, format: :js
        expect(response).to render_template :destroy
      end
    end

    context ' Not author tried delete file' do
      let(:answer) { create(:answer, files: file) }
      it 'no deletes the file' do
        expect { delete :destroy, params: { id: answer.files.first }, format: :js }
            .to_not change(answer.files, :count)
      end

      it 'redirects to root_path' do
        delete :destroy, params: { id: answer.files.first }, format: :js
        expect(response).to redirect_to root_path
      end
    end
  end
end
