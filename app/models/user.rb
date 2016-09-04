class User < ActiveRecord::Base
  rolify

  # virtual attributes
  attr_accessor :password, :password_confirmation

  belongs_to :organization
  has_many :employers
  has_many :projects

  before_save :downcase_email
  before_save :encrypt_password

  validates_confirmation_of :password
  validates_presence_of :password, :on => :create
  validates_presence_of :email
  validates_uniqueness_of :email

  def self.authenticate(email, password)
    user = find_by_email(email)

    if user && user.password_hash == BCrypt::Engine.hash_secret(password, user.password_salt)
      user
    else
      nil
    end
  end

  def all_projects
    user_ids = if is_org_admin?
      organization.user_ids
    else
      [id]
    end

    Project.where(user_id: user_ids)
  end

private

  def downcase_email
    self.email.downcase! if email.present?
  end

  def encrypt_password
    if password.present?
      self.password_salt = BCrypt::Engine.generate_salt
      self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)
    end
  end
end
