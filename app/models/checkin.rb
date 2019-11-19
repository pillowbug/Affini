class Checkin < ApplicationRecord
  belongs_to :user
  has_many :attendees
  has_many :connections, through: :attendees
end
