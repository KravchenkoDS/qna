FactoryBot.define do
  factory :oauth_application, class: 'Doorkeeper::Application' do
    name { 'Test' }
    redirect_uri { 'urn:ietf:wg:oauth:2.0:oob' }
    uid { '32165487' }
    secret { '976333211' }
  end
end
