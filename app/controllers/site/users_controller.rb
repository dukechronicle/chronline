class Site::SessionsController < Devise::SessionsController
  layout 'site'
end

class Site::RegistrationsController < Devise::RegistrationsController
  layout 'site'
end

class Site::PasswordsController < Devise::PasswordsController
  layout 'site'
end
