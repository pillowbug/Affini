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
                  against:
                  [
                    [:first_name, 'A'], [:last_name, 'A'],
                    [:email, 'B'],
                    [:description, 'C'],
                    [:facebook, 'D'], [:linkedin, 'D'], [:instagram, 'D'], [:twitter, 'D']
                  ],
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
    # nil if neither live nor frequency set
    # reference date is last_checkin if exists, otherwise live
    return nil unless live? && frequency?

    last_time = last_checkin&.time || live
    last_time.in frequency
  end

  def checkin_time_sortable
    # returns date in all cases, for sorting purpose
    # if checkin_deadline is nil, (live || created_at) in 200.years
    # if last_checkin in the future, last_checkin in 100.years
    # otherwise checkin_deadline
    cddt = checkin_deadline
    if cddt
      lc = last_checkin
      if lc && lc.time > Time.now
        lc.time.in 100.years
      else
        cddt
      end
    else
      (live || created_at).in 200.years
    end
  end

  def diligence(window = nil)
    # a mesure from of user's matching the objective of frequency vs actual checkins.
    # a value of 1 means the objective is attained (this is the max)
    # Implemented as a ratio. A better, less exploitable, not requiring forcing max at 1.0,
    # but more complex to implement measure = ratio of time in window covered by
    # (possibly overlapping) 1-period spreads around checkin dates.

    # if not live or no frequency set, nil
    return nil unless live? && frequency?

    # heuristic : default window = min(1.year, 10 * frequency)
    window ||= [1.year, 10 * frequency].min

    history_start = [checkins.past.order(time: :asc).first&.time || live, live].min
    window_end = Time.now.since(frequency) # consider checkins up to 1 period in the future
    window_start = [Time.now.since(-window), history_start].max # cannot go further back in time than initial known contact
    actual_window = window_end - window_start
    # objective is the integer quotient & should be at least 1 since actual window has at least 1 period
    # (this is enforced to avoid rounding issues)
    objective = [actual_window.to_i / frequency.to_i, 1].max
    # number of past completed checkins and scheduled future ones in the window
    n_checkins = checkins.past.completed.where('time >= ?', window_start).count +
                 checkins.future.where('time <= ?', window_end).count
    # Keep below for quick debugging:
    # p [ window_start, window_end, history_start, actual_window, frequency, objective, n_checkins]

    return [n_checkins / objective.to_f, 1.0].min
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
