class OauthCallbacksController < Devise::OmniauthCallbacksController
  before_action :oauth

  def github; end

  def vkontakte; end

  def mail_ru; end

  private

  def oauth
    auth = request.env['omniauth.auth']
    unless auth
      redirect_to new_user_session_path, alert: 'Authentication failed.'
      return
    end

    @user = User.find_for_oauth(auth)
    if @user&.confirmed?
      sign_in_and_redirect @user, event: :authentication
    else
      session['devise.oauth_uid'] = auth.uid
      session['devise.oauth_provider'] = auth.provider
      redirect_to new_user_confirmation_path
    end
  end
end
