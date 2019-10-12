shared_examples_for 'API Bad Request' do
  context 'authorized' do
    it 'return Bad Request if no resource params sended' do
      send(method, api_path, params: { access_token: access_token.token })
      expect(response.status).to eq 400
    end

    it 'return Bad Request if bad resource params sended' do
      send(method, api_path, params: bad_params)
      expect(response.status).to eq 422
    end
  end
end
