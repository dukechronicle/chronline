class Admin::SessionsController < Devise::SessionsController
  layout 'admin'
end

class Admin::InvitationsController < Devise::InvitationsController
  layout 'admin'
end

class Admin::PasswordsController < Devise::PasswordsController
  layout 'admin'
end
