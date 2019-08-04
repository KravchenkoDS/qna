require 'rails_helper'

RSpec.describe LinksController, type: :controller do

  let(:user) { create(:user) }

  let(:own_answer) { create(:answer, user: user) }

  let(:answer) { create(:answer) }

  before { login(user) }

  describe 'DELETE #destroy' do
    let!(:link) { own_answer.links.create!(name: 'google', url: 'https://www.google.com') }

    context 'author delete link' do
      it 'deletes the link from  answers links' do
        expect { delete :destroy, params: { id: link }, format: :js }
            .to change(own_answer.links, :count).by(-1)
      end

      it 'renders destroy view' do
        delete :destroy, params:  { id: link }, format: :js
        expect(response).to render_template :destroy
      end
    end

    context ' Not author delete link' do
      let!(:link) { answer.links.create!(name: 'google', url: 'https://www.google.com') }
      it 'no deletes the link' do
        expect { delete :destroy, params: { id: link }, format: :js }
            .to_not change(answer.links, :count)
      end

      it 'redirects to root_path' do
        delete :destroy, params: { id: link }, format: :js
        expect(response).to redirect_to root_path
      end
    end
  end
end
