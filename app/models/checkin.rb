class Checkin < ApplicationRecord
  belongs_to :user
  has_and_belongs_to_many :connections

  validates :description, presence: true
  validates :time, presence: true
  validates :completed, inclusion: { in: [true, false] }

  scope :past, -> { where('time < ?', Time.now) }
  scope :future, -> { where.not('time < ?', Time.now) }
  scope :completed, -> { where(completed: true) }
  scope :incomplete, -> { where(completed: false) }
  scope :feedback, -> { past.incomplete }

  def past?
    time < Time.now
  end

  def future?
    !past?
  end

  # completed? given by ActiveRecord
  def incomplete?
    !completed?
  end

  def connection?(connection)
    connections.include?(connection)
  end

  def feedback?
    past? && incomplete?
  end
end
