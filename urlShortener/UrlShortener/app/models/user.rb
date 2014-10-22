class User < ActiveRecord::Base
  validates :email, presence: true, uniqueness: true
  
  has_many(
  :submitted_urls,
  foreign_key: :user_id,
  primary_key: :id
  )
end