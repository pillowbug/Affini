class Checkin < ApplicationRecord
  belongs_to :user
  has_and_belongs_to_many :connections

  validates :time, presence: true
  validates :completed, presence: true, inclusion: { in: [true, false] }
end
