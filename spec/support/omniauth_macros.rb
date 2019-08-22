module OmniauthMacros
  def mock_auth_vkontakte
    OmniAuth.config.mock_auth[:vkontakte] = OmniAuth::AuthHash.new(
        provider: 'vkontakte',
        uid: '4181396',
        info: { email: nil }
    )
  end

  def mock_auth_mailru
    OmniAuth.config.mock_auth[:mail_ru] = OmniAuth::AuthHash.new(
        provider: 'mailru',
        uid: '1241028',
        info: { email: 'mailru@mail.ru'}
    )
  end

  def mock_auth_github
    OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(
        provider: 'github',
        uid: '1084236',
        info: { email: 'github@github.com'}
    )
  end
end
