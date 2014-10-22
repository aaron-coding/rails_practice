class ShortenedUrl < ActiveRecord::Base
  validates :long_url, presence: true, uniqueness: true
  validates :user_id, presence: true
  
  belongs_to(
    :submitter,
    class_name: 'User',
    foreign_key: :user_id,
    primary_key: :id
  )
  
  has_many(
    :visits,
    class_name: 'Visit',
    foreign_key: :short_url_id,
    primary_key: :id
  )
  
  has_many(
    :visitors,
    Proc.new { distinct }, 
    through: :visits,
    source: :user
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
  
  def self.create_for_user_and_long_url!(user, long_url)
    ShortenedUrl.create!(user_id: user.id,
                         long_url: long_url,
                         short_url: self.random_code)
  end
  
  
  def num_clicks
    Visit.where(short_url_id: self.id).count
  end
  
  def num_uniques
    visitors.count
  end
  
  def num_recent_uniques
    Visit
      .select("user_id")
      .distinct
      .where('short_url_id = ? AND created_at < ?', self.id, 10.minutes.ago)
      .count    
  end
  
end

# where -> hash syntax
# where(short_url_id: 1, created_at: Time.now)