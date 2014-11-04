# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  email           :string(255)      not null
#  password_digest :string(255)      not null
#  session_token   :string(255)      not null
#  created_at      :datetime
#  updated_at      :datetime
#

class User < ActiveRecord::Base
  validates :email, :password_digest, :session_token, presence: true
  validates :email, :session_token, uniqueness: true 
  after_initialize :ensure_session_token
  
  has_many :notes
  
  def self.generate_session_token
    SecureRandom::urlsafe_base64(16)
  end
  
  def reset_session_token!
    self.session_token = User.generate_session_token
    self.save
    self.session_token
  end
  
  def ensure_session_token
    self.session_token ||= User.generate_session_token
  end
  
  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password)
  end
  
  #review
  def password
    @password
  end
  
  def is_password?(pw)
    BCrypt::Password.new(self.password_digest).is_password?(pw)
  end
  
  
  def self.find_by_credentials(email, password)
    return if email.nil? || password.nil?
    user = User.find_by(email: email)
    return if user.nil?
    if user.is_password?(password)
      user 
    else
      nil
    end
  end
end
