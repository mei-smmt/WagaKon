class ImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick
  process resize_to_fill: [640, 640]
  
  if Rails.env.development?
    storage :file
  elsif Rails.env.test?
    storage :file
  else
    storage :fog
  end
  
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def default_url(*args)
    ActionController::Base.helpers.asset_path([version_name, "default.jpg"].compact.join('_'))
  end

  def extension_whitelist
    %w(jpg jpeg gif png)
  end
  
  def filename
    original_filename if original_filename
  end
end
