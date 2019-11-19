class Checkin < ApplicationRecord
  belongs_to :user
  has_and_belongs_to_many :connections

  validates :time, presence: true
  validates :completed, inclusion: { in: [true, false] }
end
