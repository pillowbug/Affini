class Attendee < ApplicationRecord
  belongs_to :checkin
  belongs_to :connection
end
