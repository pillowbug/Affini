class Connection < ApplicationRecord
  belongs_to :user
  has_many :glances
  has_and_belongs_to_many :checkins
  has_and_belongs_to_many :tags

  mount_uploader :photo, PhotoUploader
end
