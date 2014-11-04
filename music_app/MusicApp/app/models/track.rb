# == Schema Information
#
# Table name: tracks
#
#  id         :integer          not null, primary key
#  name       :string(255)      not null
#  album_id   :integer          not null
#  created_at :datetime
#  updated_at :datetime
#  bonus      :string(255)      not null
#  lyrics     :text             not null
#

class Track < ActiveRecord::Base
  validates :name, :album_id, :lyrics, presence: true
  validates :bonus, inclusion: ["bonus", "regular"]
  
  belongs_to :album
  has_many :notes
end
