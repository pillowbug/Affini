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
      image_tag('user_placeholder.png', args)
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

  def connection_status(connection)
    status = []
    if connection.live?
      if connection.frequency?
        status << ['Frequency:', frequency_display(connection.frequency)]
        last_checkin = connection.last_checkin
        if last_checkin && last_checkin.time > Time.now
          status << ['Next:', date_display(last_checkin.time)]
        else
          if last_checkin
            # status << ['Last:', date_display(last_checkin.time)]
          end
          status << ['Next due by:', date_display(connection.checkin_deadline)]
        end
      end
    else
      status << ['Pending', '']
      # status << ['Imported on:', date_display(connection.created_at)]
    end
    return status
  end

  def dilligence_messages(connection)
    level1 = ['Baby steps..', 'Good start!', 'Keep at it!']
    level2 = ['Moving up!', 'Getting there!', 'Press on!']
    level3 = ['Almost there!', 'Great work!', 'Hurray!']
    level4 = ['You did it!', 'Rad!', 'Nice job!']
    if connection.diligence > 0.75
      return level4.sample
    elsif connection.diligence > 0.50
      return level3.sample
    elsif connection.diligence > 0.25
      return level2.sample
    else
      return level1.sample
    end
  end
end
