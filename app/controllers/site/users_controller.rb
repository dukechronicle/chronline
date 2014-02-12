class Site::SessionsController < Devise::SessionsController
  layout 'site'
end

class Site::RegistrationsController < Devise::RegistrationsController
  layout 'site'
end

class Site::PasswordsController < Devise::PasswordsController
  layout 'site'
end

class Site::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  layout 'site'

  def facebook
    oauth_callback('facebook')
  end

  def google_oauth2
    oauth_callback('google')
  end

  private
  def oauth_callback(provider)
    user = User.find_for_oauth(provider, request.env["omniauth.auth"])
    if user.persisted?
      sign_in_and_redirect user, event: :authentication
      if is_navigational_format?
        set_flash_message(:notice, :success, kind: provider.titleize)
      end
    else
      session["devise.facebook_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end
end
