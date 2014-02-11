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
    @user = User.find_for_facebook_oauth(request.env["omniauth.auth"])

    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      if is_navigational_format?
        set_flash_message(:notice, :success, kind: 'Facebook')
      end
    else
      session["devise.facebook_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end

  def google_oauth2
    @user = User.find_for_google_oauth(request.env["omniauth.auth"])

    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      if is_navigational_format?
        set_flash_message(:notice, :success, kind: 'Google')
      end
    else
      session["devise.facebook_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end
end
