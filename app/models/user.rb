class User < ActiveRecord::Base
  Roles = %w(user admin)

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable
  devise :database_authenticatable, :registerable, :recoverable, :validatable,
    :rememberable, :trackable
  devise :omniauthable, omniauth_providers: [:facebook, :google_oauth2]

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me,
    :first_name, :last_name

  validates :first_name, presence: true
  validates :last_name, presence: true

  has_many :brackets, class_name: 'Tournament::Bracket'

  default_value_for :role, Roles[0]

  def name
    "#{first_name} #{last_name}"
  end

  def admin?
    role.to_s == 'admin'
  end

  class << self
    def find_for_oauth(provider, auth)
      t = self.arel_table
      query = t["#{provider}_uid"].eq(auth.uid)
        .or(t[:email].eq(auth.info.email))
      user = self.where(query).first_or_create do |user|
        user.email = auth.info.email
        user.password = Devise.friendly_token[0,20]
        user.first_name = auth.info.first_name
        user.last_name = auth.info.last_name
      end
      if user["#{provider}_uid"].nil?
        user["#{provider}_uid"] = auth.uid
        user.save
      end
      user
    end
  end
end
