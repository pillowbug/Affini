module ConnectionHelper
  def connection_image_path(connection)
    if connection.photo.file
      cl_image_path(connection.photo)
    else
      asset_url('user_placeholder.png')
    end
  end

  def last_checkin_date_display(connection)
    if connection.last_completed_past_checkin.nil?
      "Never"
    else
      connection.last_completed_past_checkin.time.strftime("%a %d %b")
    end
  end
end
