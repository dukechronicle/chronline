class User < ActiveRecord::Base
  Roles = %w(user admin)

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :validatable,
    :rememberable, :trackable

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
end
