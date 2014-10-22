class ShortenedUrl < ActiveRecord::Base
  validates :long_url, :user_id, presence: true, uniqueness: true
  
  belongs_to(
  :submitter,
  class_name: 'User',
  foreign_key: :user_id,
  primary_key: :id
  )
  
  def self.random_code
    code_unique = false
    
    until code_unique
      code = SecureRandom::urlsafe_base64
      unless exists?(:short_url => code) 
        code_unique = true
      end
    end
    
    code
  end
  
  def self.create_for_user_and_long_url!(user_id, long_url)
    ShortenedUrl.create!(user_id: user_id,
                         long_url: long_url,
                         short_url: self.random_code)
  end
  
end