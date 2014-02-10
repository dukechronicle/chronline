class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  # :rememberable, :trackable
  devise :database_authenticatable, :registerable, :recoverable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me,
    :first_name, :last_name

  validates :first_name, presence: true
  validates :last_name, presence: true

  def name
    "#{first_name} #{last_name}"
  end

  def admin?
    role.to_s == 'admin'
  end
end
