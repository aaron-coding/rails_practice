class Note < ActiveRecord::Base
  validates :note, presence: true
  validates :user, :track, presence: true
  
  belongs_to :user
  belongs_to :track
end
