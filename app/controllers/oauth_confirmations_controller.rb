class OauthConfirmationsController < Devise::ConfirmationsController
  def create
    @email = oauth_confirmation_params[:email]
    password = Devise.friendly_token[0, 20]
    @user = User.new(email: @email, password: password, password_confirmation: password)

    if @user.valid?
      @user.send_confirmation_instructions
    else
      flash.now[:alert] = 'enter valid email'
      render :new
    end
  end

  private

  def after_confirmation_path_for(resource_name, user)
    user.authorizations.create(provider: session[:provider], uid: session[:uid])
    signed_in_root_path(@user)
  end

  def oauth_confirmation_params
    params.permit(:email)
  end
end
