class PhotoUploader < CarrierWave::Uploader::Base
  include Cloudinary::CarrierWave

  process eager: true

  process convert: 'jpg'

  version :thumbnail do
    resize_to_fit 256, 256
  end
end
