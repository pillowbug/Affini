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

  def birthday_display(dte)
    dte ? dte.strftime("%a %d %b") : "Unknown"
  end

  def date_display(dte)
    dte ? dte.strftime("%a %d %b %y") : "Never"
  end

  def checkin_date_display(checkin)
    checkin ? date_display(checkin.time) : "Never"
  end

  def last_checkin_date_display(connection)
    checkin_date_display(connection.last_completed_past_checkin)
  end
end
