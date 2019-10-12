shared_examples_for 'API Creatable' do
  it_behaves_like 'API Authorizable' do
    let(:headers) { nil }
  end

  it_behaves_like 'API Bad Request'

  context 'authorized' do
    it 'create new resource' do
      expect { post api_path, params: params}.to change(klass, :count).by(1)
    end
  end
end
