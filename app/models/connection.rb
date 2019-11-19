class Connection < ApplicationRecord
  belongs_to :user
  has_many :attendees
  has_many :checkins, through: :attendees
  has_many :connection_tags
  has_many :tags, through: :connection_tags
  has_many :glances

  mount_uploader :photo, PhotoUploader
end
