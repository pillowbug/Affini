module ApplicationHelper
  def connection_image_path(connection)
    if connection.photo.file
      cl_image_path(connection.photo)
    else
      asset_url('user_placeholder.png')
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

  def birthday_display(dte, missing = "Unknown")
    dte ? dte.strftime("%a %d %b") : missing
  end
end
