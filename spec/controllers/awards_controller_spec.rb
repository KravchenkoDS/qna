require 'rails_helper'

RSpec.describe AwardsController, type: :controller do

  let(:user) { create(:user) }

  before { login(user) }

  describe 'GET #index' do

    before { get :index}

    it 'all users awards' do
      expect(assigns(:awards)).to match_array(user.awards)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end
end
