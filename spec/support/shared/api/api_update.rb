shared_examples_for 'API Updatable' do
  it_behaves_like 'API Authorizable' do
    let(:headers) { nil }
  end

  it_behaves_like 'API Bad Request'

  context 'authorized' do
    it 'update resource' do
      patch api_path, params: params
      resource.reload
      expect(resource.attributes[updated_attribute]).to eq updated_value
    end
  end
end
