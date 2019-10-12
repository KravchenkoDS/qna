shared_examples_for 'API Deletable' do
  it_behaves_like 'API Authorizable' do
    let(:method) { :delete }
    let(:headers) { nil }
    let(:params) { { access_token: access_token.token } }
  end

  context 'authorized' do
    it "deleted resource" do
      expect{ delete api_path, params: { access_token: access_token.token } }.to change(resource.class, :count).by(-1)
    end
  end
end
