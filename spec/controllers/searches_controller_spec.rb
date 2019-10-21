require 'rails_helper'

RSpec.describe SearchesController, type: :controller do

  describe "POST #search" do
    let(:params) { { search_type: "", search_string: "" } }
    let(:service) { double('Services::Search') }

    before do
      expect(Services::Search).to receive(:new).with(params).and_return(service)
    end

    it 'calls Services::Search#result' do
      expect(service).to receive(:call)
      get :search, params: { search: params }
    end
  end
end
