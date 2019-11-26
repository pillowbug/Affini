module ApplicationHelper
  def connection_image_path(connection, args = {})
    if connection.photo.file
      cl_image_path(connection.photo, args)
    else
      asset_url('user_placeholder.png', args)
    end
  end

  def connection_image_tag(connection, args = {})
    if connection.photo.file
      cl_image_tag(connection.photo, args)
    else
      # raise
      image_tag('user_placeholder.png', class: 'avatar-xl')
    end
  end

  def full_name(person)
    "#{person.first_name} #{person.last_name}"
  end

  def datetime_display(dte, missing = "Never")
    dte ? dte.strftime("%a %d %b %Y %k:%M") : missing
  end

  def date_display(dte, missing = "Never")
    dte ? dte.strftime("%a %d %b %Y") : missing
  end

  def checkin_date_display(checkin, missing = "Never")
    checkin ? date_display(checkin.time, missing) : missing
  end

  def last_checkin_date_display(connection, missing = "Never")
    checkin_date_display(connection.last_completed_past_checkin, missing)
  end

  def checkin_deadline_display(connection, missing = "Never", past = "ASAP", prefix = "by ")
    dte = connection.checkin_deadline
    if dte
      dte > Time.now ? "#{prefix}#{date_display(dte)}" : past
    else
      missing
    end
  end

  def birthday_display(dte, missing = "Unknown")
    dte ? dte.strftime("%d %b") : missing
  end

  def frequency_display(duration, missing = "Never")
    duration ? "Every #{duration.inspect.gsub(/^1 /, '')}" : missing
  end

  def pluralize_with_no(word, count)
    count.zero? ? "no #{word}" : "#{count} #{word.pluralize(count)}"
  end

  def duration_units
    [:days, :weeks, :months, :years]
  end

  def duration_value(duration)
    duration&.is_a?(ActiveSupport::Duration) ? duration.parts.first[1] : 0
  end

  def duration_unit_index(duration)
    duration&.is_a?(ActiveSupport::Duration) ? duration.parts.first[0] : :months
  end

  # def dashboard_message(args = {})
  #   return "Nothing requires your immediate attention. Good job!" if args.empty? || args.sum{ |_, n| n }.zero?

  #   actions = []
  #   if args[:n_feedbacks] && args[:n_feedbacks].positive?
  #     actions << ("have " + pluralize_with_no("past check-in", args[:n_feedbacks]) + " to give feedback on")
  #   end
  #   if args[:n_connections_checkin] && args[:n_connections_checkin].positive?
  #     actions << ("should get back in touch with " + pluralize_with_no("connection", args[:n_connections_checkin]))
  #   end
  #   if args[:n_upcomings] && args[:n_upcomings].positive?
  #     actions << ("have " + pluralize_with_no("upcoming check-in", args[:n_upcomings]) + " next week")
  #   end
  #   "You " + actions.to_sentence + "."
  # end
end
