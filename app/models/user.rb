class User < ActiveRecord::Base
  Roles = %w(user admin)

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable
  devise :database_authenticatable, :registerable, :recoverable, :validatable,
    :rememberable, :trackable
  devise :omniauthable, omniauth_providers: [:facebook]

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me,
    :first_name, :last_name

  validates :first_name, presence: true
  validates :last_name, presence: true

  default_value_for :role, Roles[0]

  def name
    "#{first_name} #{last_name}"
  end

  def admin?
    role.to_s == 'admin'
  end

  class << self
    def find_for_facebook_oauth(auth)
      where(auth.slice(:provider, :uid)).first_or_create do |user|
        user.provider = auth.provider
        user.uid = auth.uid
        user.email = auth.info.email
        user.password = Devise.friendly_token[0,20]
        user.first_name = auth.info.first_name
        user.last_name = auth.info.last_name
      end
    end
  end
end
