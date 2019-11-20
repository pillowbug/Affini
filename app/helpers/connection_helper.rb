module ConnectionHelper
  def connection_image_path(connection)
    if connection.photo.file
      cl_image_path(connection.photo)
    else
      asset_url('user_placeholder.png')
    end
  end
end
