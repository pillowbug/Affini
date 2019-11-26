class Connection < ApplicationRecord
  attribute :frequency, :duration

  belongs_to :user
  has_many :glances, dependent: :destroy
  has_and_belongs_to_many :checkins
  has_and_belongs_to_many :tags

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, allow_blank: true, format: { with: URI::MailTo::EMAIL_REGEXP }

  scope :live, -> { where.not(live: nil) }
  scope :pending, -> { where(live: nil) }

  mount_uploader :photo, PhotoUploader

  before_save :data_cleanup

  include PgSearch::Model
  pg_search_scope :search,
                  against: %i[description facebook linkedin email twitter first_name last_name],
                  using: {
                    tsearch: { prefix: true } # <-- now `superman batm` will return something!
                  }

  def last_checkin
    # checkin with latest date, incl. in the future; nil if no checkin
    checkins.order(time: :desc).first
  end

  def last_completed_past_checkin
    # checkin with latest date, only past; nil if no checkin
    checkins.past.completed.order(time: :desc).first
  end

  def checkin_deadline
    # returns date by which next checkin shall be scheduled
    # nil if no target frequency, creation time stamp
    return nil if frequency.nil?

    last_time = last_checkin&.time || created_at
    last_time.in frequency
  end

  def to_s
    first_name
  end

  private

  # def send_connection_email
  #   ConnectionMailer.
  # end

  def data_cleanup
    self.email = email.strip if email
  end
end
