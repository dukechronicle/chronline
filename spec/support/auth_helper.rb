module AuthHelper
  def http_auth(user)
    ActionController::HttpAuthentication::Basic.encode_credentials(
     user.email, user.password)
  end
end
